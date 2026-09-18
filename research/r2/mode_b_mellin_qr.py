#!/usr/bin/env python3
"""
R2 Mode B v2: Mellin-side QR with holdout-selected regularization.

Goal: construct useful finite coefficient vectors without inverting G_N.

For v_N = sum c_n rho_n,
  M(chi-v_N)(s) = (1 + zeta(s) P_c(s))/s,
  P_c(s)=sum c_n n^(-s).

The first global QR experiment on |t|<=N^2 with O(N) samples was deliberately
kept as a falsification result: from N=64 onward it under-resolved the
Dirichlet oscillations, overfit the sampled continuum, and Arb evaluation
showed huge true L2 errors.

v2 therefore:
  * trains only on a resolved finite window |t|<=T_train;
  * uses a uniform midpoint grid fine enough for the largest log-frequency;
  * splits alternating nodes into train/validation sets;
  * column-scales the real design matrix;
  * scans ridge strengths, each solved by QR/LAPACK GELSY;
  * selects lambda by independent validation energy;
  * evaluates the selected decimal coefficient vector in the exact finite
    Gram quadratic form with Arb.

The finite Mellin window is a coefficient-construction heuristic. Arb Gram
evaluation, not the sampled residual, is the authoritative finite L2 error.
No finite result proves DNLimit=0 or RH.
"""
from __future__ import annotations

import argparse
import json
import math
import pathlib
import sys

import mpmath as mp
import numpy as np
import scipy.linalg

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from gram_engine import b_arb, gram_arb, mobius_int


MODE_A_DN = {
    8: "0.02416142158589668502280894301085134",
    16: "0.01789402347696943509905506314795876",
    32: "0.01405194369952985983642504072212329",
    64: "0.01137604029967365814705897002932677",
    128: "0.009658549278111909910035392571452577",
    256: "0.008233716277261021441598038102635435",
}

DEFAULT_RIDGES = (0.0, 1e-12, 1e-10, 1e-8, 1e-6, 1e-4, 1e-2)


def parse_schedule(raw: str) -> list[int]:
    out=[int(x.strip()) for x in raw.split(",") if x.strip()]
    if not out or any(n < 2 for n in out):
        raise ValueError("schedule must contain N >= 2")
    return out


def resolved_grid(N: int, T_train: float, samples_per_period: float):
    """Midpoint grid resolving exp(-it log n) up to n=N.

    The shortest phase period is 2*pi/log(N). We request
    samples_per_period points per shortest period, then double the grid so
    alternating points form independent train/validation sets.
    """
    shortest = 2.0 * math.pi / math.log(N)
    dt_target = shortest / samples_per_period
    half_count = max(64, math.ceil(T_train / dt_target))
    total = 2 * half_count
    dt = T_train / total
    t = (np.arange(total, dtype=np.float64) + 0.5) * dt
    # Full even Mellin energy on positive t has factor 1/pi.
    weights = np.full(total, dt / math.pi, dtype=np.float64) / (0.25 + t*t)
    return t, weights, dt


def complex_design(N: int, t: np.ndarray, zeta_dps: int):
    mp.mp.dps=zeta_dps
    logs=np.log(np.arange(1,N+1,dtype=np.float64))
    A=np.empty((len(t),N),dtype=np.complex128)
    for k,tk in enumerate(t):
        s=mp.mpf("0.5")+1j*mp.mpf(repr(float(tk)))
        z=complex(mp.zeta(s))
        A[k,:]=z*np.exp((-0.5-1j*tk)*logs)
    return A


def real_weighted_system(A: np.ndarray, weights: np.ndarray):
    root=np.sqrt(weights)
    Aw=A*root[:,None]
    target=-root
    M=np.vstack([Aw.real,Aw.imag])
    y=np.concatenate([target,np.zeros_like(target)])
    return M,y


def scaled_qr_ridge(M: np.ndarray, y: np.ndarray, lam: float):
    col=np.linalg.norm(M,axis=0)
    col=np.where(col>0,col,1.0)
    Ms=M/col[None,:]
    ys=y
    if lam>0:
        n=Ms.shape[1]
        Ms=np.vstack([Ms,math.sqrt(lam)*np.eye(n)])
        ys=np.concatenate([ys,np.zeros(n)])
    z,_,rank,_=scipy.linalg.lstsq(
        Ms,ys,cond=None,lapack_driver="gelsy",check_finite=True
    )
    c=z/col
    svals=scipy.linalg.svdvals(M/col[None,:])
    cond=float(svals[0]/svals[-1]) if svals[-1]>0 else math.inf
    return c,int(rank),cond


def weighted_energy(A: np.ndarray,weights: np.ndarray,c: np.ndarray):
    r=1.0+A@c
    return float(np.sum(weights*np.abs(r)**2))


def bcf_linear_coefficients(N:int):
    logN=math.log(N)
    c=np.zeros(N,dtype=np.float64)
    for n in range(1,N+1):
        mu=mobius_int(n)
        if mu:
            c[n-1]=-mu*(1.0-math.log(n)/logN)
    return c


def build_arb_gram(N:int,dps:int):
    from flint import arb,arb_mat,ctx
    ctx.dps=dps
    entries=[arb(0) for _ in range(N*N)]
    bvals=[]
    for i in range(N):
        a=i+1
        bvals.append(b_arb(a,dps))
        for j in range(i+1):
            g=gram_arb(a,j+1,dps)
            entries[i*N+j]=g
            entries[j*N+i]=g
    return arb_mat(N,N,entries),arb_mat(N,1,bvals)


def arb_error_from_built(G,B,c:np.ndarray):
    from flint import arb,arb_mat
    C=arb_mat(len(c),1,[arb(format(float(x),".17g")) for x in c])
    e=arb(1)-2*(B.transpose()*C)[0,0]+(C.transpose()*G*C)[0,0]
    return {
        "ball":e.str(50,more=True),
        "lower":e.lower().str(50,radius=False),
        "upper":e.upper().str(50,radius=False),
    }


def run_one(N:int,T_train:float,samples_per_period:float,zeta_dps:int,arb_dps:int):
    t,w,dt=resolved_grid(N,T_train,samples_per_period)
    A=complex_design(N,t,zeta_dps)

    train=np.arange(len(t))%2==0
    valid=~train
    Mtr,ytr=real_weighted_system(A[train],2*w[train])
    # doubled weights compensate for using half of midpoint nodes
    Aval=A[valid]
    wval=2*w[valid]

    scans=[]
    candidates=[]
    for lam in DEFAULT_RIDGES:
        c,rank,cond=scaled_qr_ridge(Mtr,ytr,lam)
        tr=weighted_energy(A[train],2*w[train],c)
        va=weighted_energy(Aval,wval,c)
        scans.append({
            "lambda":lam,
            "train_E2_window":tr,
            "validation_E2_window":va,
            "rank":rank,
            "scaled_design_condition":cond,
            "coeff_l2":float(np.linalg.norm(c)),
            "coeff_l1":float(np.linalg.norm(c,ord=1)),
            "max_abs_coeff":float(np.max(np.abs(c))),
        })
        candidates.append(c)

    best_i=min(range(len(scans)),key=lambda i:scans[i]["validation_E2_window"])
    chosen=candidates[best_i]
    chosen_meta=scans[best_i]

    G,B=build_arb_gram(N,arb_dps)
    chosen_arb=arb_error_from_built(G,B,chosen)
    bcf=bcf_linear_coefficients(N)
    bcf_arb=arb_error_from_built(G,B,bcf)
    bcf_window=weighted_energy(A,w,bcf)

    ref=float(MODE_A_DN[N])
    cmid=0.5*(float(chosen_arb["lower"])+float(chosen_arb["upper"]))
    bmid=0.5*(float(bcf_arb["lower"])+float(bcf_arb["upper"]))

    return {
        "classification":"MODE_B_V2_HOLDOUT_QR_FINITE_N_RESEARCH",
        "N":N,
        "training_window_abs_t":T_train,
        "grid_total_points":len(t),
        "grid_dt":dt,
        "samples_per_shortest_period_target":samples_per_period,
        "zeta_dps":zeta_dps,
        "arb_dps":arb_dps,
        "uses_gram_inverse_for_coefficients":False,
        "ridge_scan":scans,
        "selected":{
            **chosen_meta,
            "selection_rule":"minimum independent validation-window energy",
            "arb_full_finite_gram_E2":chosen_arb,
            "mode_A_optimal_DN_reference":MODE_A_DN[N],
            "arb_E2_minus_mode_A_mid":cmid-ref,
        },
        "bcf_linear_mollifier":{
            "family":"-mu(n)*(1-log(n)/log(N))",
            "window_E2":bcf_window,
            "arb_full_finite_gram_E2":bcf_arb,
            "E2_logN_mid":bmid*math.log(N),
            "coeff_l2":float(np.linalg.norm(bcf)),
            "coeff_l1":float(np.linalg.norm(bcf,ord=1)),
        },
        "scope":{
            "window_tail_certified":False,
            "statement":(
                "The window/holdout system constructs coefficients only. "
                "The Arb Gram quadratic form certifies the exact finite L2 "
                "error of the selected decimal vector. No Mellin-window tail "
                "estimate is used to promote DNLimit or RH."
            )
        },
        "dnlimit_eq_zero_proved":False,
        "rh_proved":False,
    }


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--schedule",default="8,16,32,64,128,256")
    ap.add_argument("--T-train",type=float,default=250.0)
    ap.add_argument("--samples-per-period",type=float,default=8.0)
    ap.add_argument("--zeta-dps",type=int,default=50)
    ap.add_argument("--arb-dps",type=int,default=100)
    ap.add_argument("--jsonl",default="")
    a=ap.parse_args()

    rows=[]
    for N in parse_schedule(a.schedule):
        r=run_one(N,a.T_train,a.samples_per_period,a.zeta_dps,a.arb_dps)
        rows.append(r)
        print(json.dumps(r,sort_keys=True))
    if a.jsonl:
        with open(a.jsonl,"w",encoding="utf-8") as f:
            for r in rows:
                f.write(json.dumps(r,sort_keys=True)+"\n")


if __name__=="__main__":
    main()
