#!/usr/bin/env python3
"""
R2 Gram engine for the concrete Nyman--Beurling/Baez-Duarte model.

chi = 1_(0,1)
rho_a(x) = frac(1/(a*x))
ambient measure = dx on (0,infinity)

This file is RESEARCH / MODEL_EVIDENCE unless an Arb interval is emitted.
No finite computation proves DNLimit = 0.
"""
from __future__ import annotations
import argparse
import json
import math
from functools import lru_cache

def _schedule(s: str):
    out=[]
    for part in s.split(","):
        part=part.strip()
        if part:
            n=int(part)
            if n < 1:
                raise ValueError("N must be >= 1")
            out.append(n)
    return out

@lru_cache(maxsize=None)
def vasyunin_mpmath(p:int,q:int,dps:int=80):
    import mpmath as mp
    mp.mp.dps=dps
    if math.gcd(p,q)!=1:
        raise ValueError("V(p,q) expects gcd(p,q)=1")
    if q==1:
        return mp.mpf("0")
    s=mp.mpf("0")
    for k in range(1,q):
        r=(k*p)%q
        angle=mp.pi*k/q
        s += (mp.mpf(r)/q)*mp.cot(angle)
    return s

@lru_cache(maxsize=None)
def gram_mpmath(a:int,b:int,dps:int=80):
    import mpmath as mp
    mp.mp.dps=dps
    d=math.gcd(a,b)
    p,q=a//d,b//d
    term=(mp.log(2*mp.pi)-mp.euler)/2*(mp.mpf(1)/p+mp.mpf(1)/q)
    term += mp.mpf(p-q)/(2*p*q)*mp.log(mp.mpf(q)/p)
    term -= mp.pi/(2*p*q)*(vasyunin_mpmath(q,p,dps)+vasyunin_mpmath(p,q,dps))
    return term/d

def b_mpmath(a:int,dps:int=80):
    import mpmath as mp
    mp.mp.dps=dps
    return (mp.log(a)+1-mp.euler)/a

def run_mpmath(N:int,dps:int):
    import mpmath as mp
    mp.mp.dps=dps
    G=mp.matrix(N,N)
    b=mp.matrix(N,1)
    for i in range(N):
        a=i+1
        b[i]=b_mpmath(a,dps)
        for j in range(i+1):
            val=gram_mpmath(a,j+1,dps)
            G[i,j]=val
            G[j,i]=val
    c=mp.lu_solve(G,b)
    DN=mp.mpf(1)-(b.T*c)[0]
    logN=mp.log(N) if N>1 else mp.mpf(0)
    return {
        "backend":"mpmath",
        "classification":"MODEL_EVIDENCE_ONLY",
        "N":N,
        "dps":dps,
        "DN_mid":mp.nstr(DN,40),
        "DN_logN_mid":mp.nstr(DN*logN,40),
        "d_sqrt_logN_mid":mp.nstr(mp.sqrt(DN*logN),40) if N>1 and DN>=0 else None,
        "coefficients_mid":[mp.nstr(c[i],30) for i in range(N)],
        "dnlimit_eq_zero_proved":False,
        "rh_proved":False,
    }

def _arb_bounds(x,digits=50):
    return {
        "ball":x.str(digits,more=True),
        "lower":x.lower().str(digits,radius=False),
        "upper":x.upper().str(digits,radius=False),
    }

@lru_cache(maxsize=None)
def vasyunin_arb(p:int,q:int,dps:int=80):
    from flint import arb,ctx
    ctx.dps=dps
    if math.gcd(p,q)!=1:
        raise ValueError("V(p,q) expects gcd(p,q)=1")
    if q==1:
        return arb(0)
    pi=arb.pi()
    s=arb(0)
    for k in range(1,q):
        r=(k*p)%q
        angle=pi*k/q
        s += (arb(r)/q)*(angle.cos()/angle.sin())
    return s

@lru_cache(maxsize=None)
def gram_arb(a:int,b:int,dps:int=80):
    from flint import arb,ctx
    ctx.dps=dps
    d=math.gcd(a,b)
    p,q=a//d,b//d
    gamma=arb.const_euler()
    pi=arb.pi()
    term=((arb(2)*pi).log()-gamma)/2*(arb(1)/p+arb(1)/q)
    term += arb(p-q)/(2*p*q)*(arb(q)/p).log()
    term -= pi/(2*p*q)*(vasyunin_arb(q,p,dps)+vasyunin_arb(p,q,dps))
    return term/d

def b_arb(a:int,dps:int=80):
    from flint import arb,ctx
    ctx.dps=dps
    return (arb(a).log()+1-arb.const_euler())/a

def mobius_int(n:int) -> int:
    """Elementary Möbius function for finite research coefficient diagnostics."""
    m=n
    parity=0
    p=2
    while p*p<=m:
        if m%p==0:
            e=0
            while m%p==0:
                m//=p
                e+=1
            if e>1:
                return 0
            parity+=1
        p+=1
    if m>1:
        parity+=1
    return 1 if parity%2==0 else -1


def explicit_candidate_error_arb(G,B,N:int,kind:str):
    """Rigorous finite-N squared error for an explicit coefficient family."""
    from flint import arb,arb_mat
    if N<=1:
        raise ValueError("candidate taper requires N > 1")
    logN=arb(N).log()
    vals=[]
    for n in range(1,N+1):
        mu=mobius_int(n)
        if mu==0:
            vals.append(arb(0))
            continue
        u=arb(1)-arb(n).log()/logN
        if kind=="sqrt_log_taper":
            weight=u.sqrt()
        elif kind=="linear_log_taper":
            weight=u
        elif kind=="raw_mobius":
            weight=arb(1)
        else:
            raise ValueError(kind)
        vals.append(-mu*weight)
    C=arb_mat(N,1,vals)
    err=arb(1)-2*(B.transpose()*C)[0,0]+(C.transpose()*G*C)[0,0]
    return err


def scaled_power_taper_scan_arb(G,B,N:int):
    """Finite-N Arb scan of scaled Möbius power tapers in Gram energy.

    For v_n = -mu(n) * u_n^alpha, u_n=1-log(n)/log(N), optimize the
    scalar A exactly in the finite quadratic error:
        E(A)^2 = 1 - 2 A <b,v> + A^2 <v,Gv>.
    This is finite-N model evidence only.
    """
    from flint import arb,arb_mat
    if N<=1:
        raise ValueError("power taper scan requires N > 1")
    logN=arb(N).log()

    def weight(u, kind):
        if kind=="alpha_0":
            return arb(1)
        q=u.sqrt().sqrt()
        h=u.sqrt()
        if kind=="alpha_1_4":
            return q
        if kind=="alpha_1_2":
            return h
        if kind=="alpha_3_4":
            return h*q
        if kind=="alpha_1":
            return u
        if kind=="alpha_3_2":
            return u*h
        if kind=="alpha_2":
            return u*u
        raise ValueError(kind)

    out={}
    for kind in [
        "alpha_0","alpha_1_4","alpha_1_2","alpha_3_4",
        "alpha_1","alpha_3_2","alpha_2"
    ]:
        vals=[]
        for n in range(1,N+1):
            mu=mobius_int(n)
            if mu==0:
                vals.append(arb(0))
                continue
            u=arb(1)-arb(n).log()/logN
            vals.append(-mu*weight(u,kind))
        V=arb_mat(N,1,vals)
        L=(B.transpose()*V)[0,0]
        Q=(V.transpose()*G*V)[0,0]
        if not (Q.lower()>0):
            raise ArithmeticError(f"non-positive Gram energy for {kind}: {Q}")
        A=L/Q
        err=arb(1)-(L*L)/Q
        out[kind]={
            "optimal_scale":_arb_bounds(A),
            "optimized_squared_error":_arb_bounds(err),
            "linear_term":_arb_bounds(L),
            "quadratic_energy":_arb_bounds(Q),
        }
    return out


def scaled_mobius_dyadic_scan_arb(G,B,N:int,denom_power:int=4):
    """Rigorous finite-N scan alpha=m/2^denom_power for 0<=alpha<=1.

    The base root u^(1/2^denom_power) is formed by repeated square roots;
    integer powers are formed by multiplication, avoiding a floating exponent.
    Each shape gets its optimal scalar amplitude in the Gram energy.
    """
    from flint import arb,arb_mat
    if N<=1:
        raise ValueError("dyadic taper scan requires N > 1")
    if denom_power<1:
        raise ValueError("denom_power must be >= 1")
    den=2**denom_power
    logN=arb(N).log()
    out={}

    for m in range(den+1):
        vals=[]
        for n in range(1,N+1):
            mu=mobius_int(n)
            if mu==0:
                vals.append(arb(0))
                continue
            u=arb(1)-arb(n).log()/logN
            if m==0:
                w=arb(1)
            else:
                root=u
                for _ in range(denom_power):
                    root=root.sqrt()
                w=arb(1)
                for _ in range(m):
                    w*=root
            vals.append(-mu*w)

        V=arb_mat(N,1,vals)
        L=(B.transpose()*V)[0,0]
        Q=(V.transpose()*G*V)[0,0]
        if not (Q.lower()>0):
            raise ArithmeticError(f"non-positive Gram energy for alpha={m}/{den}: {Q}")
        A=L/Q
        err=arb(1)-(L*L)/Q
        fixed_err=arb(1)-2*L+Q
        out[f"alpha_{m}_{den}"]={
            "alpha_num":m,
            "alpha_den":den,
            "optimal_scale":_arb_bounds(A),
            "optimized_squared_error":_arb_bounds(err),
            "fixed_scale_one_squared_error":_arb_bounds(fixed_err),
        }

    return out


def optimal_coefficient_diagnostics(C,N:int):
    """Descriptive finite-N diagnostics only; no asymptotic inference."""
    vals=[float(C[i,0].mid()) for i in range(N)]
    sf=0
    match=0
    sf_abs=0.0
    nsf_abs=0.0
    nsf=0
    for i,c in enumerate(vals, start=1):
        mu=mobius_int(i)
        if mu:
            sf+=1
            sf_abs+=abs(c)
            if (c>0)==(-mu>0):
                match+=1
        else:
            nsf+=1
            nsf_abs+=abs(c)
    return {
        "squarefree_count":sf,
        "minus_mobius_sign_matches":match,
        "minus_mobius_sign_match_rate":match/sf if sf else None,
        "mean_abs_optimal_coeff_squarefree":sf_abs/sf if sf else None,
        "mean_abs_optimal_coeff_nonsquarefree":nsf_abs/nsf if nsf else None,
        "classification":"MODEL_EVIDENCE_ONLY"
    }


def run_arb(N:int,dps:int):
    import flint
    from flint import arb,arb_mat,ctx
    ctx.dps=dps
    entries=[arb(0) for _ in range(N*N)]
    bvals=[]
    for i in range(N):
        a=i+1
        bvals.append(b_arb(a,dps))
        for j in range(i+1):
            val=gram_arb(a,j+1,dps)
            entries[i*N+j]=val
            entries[j*N+i]=val
    G=arb_mat(N,N,entries)
    B=arb_mat(N,1,bvals)
    C=G.solve(B,algorithm="precond")
    DN=arb(1)-(B.transpose()*C)[0,0]
    logN=arb(N).log() if N>1 else arb(0)
    det=G.det()
    candidate_errors={
        "raw_mobius":_arb_bounds(explicit_candidate_error_arb(G,B,N,"raw_mobius")),
        "sqrt_log_taper":_arb_bounds(explicit_candidate_error_arb(G,B,N,"sqrt_log_taper")),
        "linear_log_taper":_arb_bounds(explicit_candidate_error_arb(G,B,N,"linear_log_taper")),
    }
    coeff_diagnostics=optimal_coefficient_diagnostics(C,N)
    scaled_power_scan=scaled_power_taper_scan_arb(G,B,N)
    dyadic_scan=scaled_mobius_dyadic_scan_arb(G,B,N,denom_power=4)
    return {
        "backend":"python-flint/arb",
        "python_flint_version":flint.__version__,
        "classification":"INTERVAL_CERTIFIED_FINITE_N",
        "N":N,
        "dps":dps,
        "gram_invertibility_certified_by_rigorous_solve":True,
        "gram_det":_arb_bounds(det),
        "DN":_arb_bounds(DN),
        "DN_logN":_arb_bounds(DN*logN),
        "d_sqrt_logN":_arb_bounds((DN*logN).sqrt()) if N>1 and DN.lower()>=0 else None,
        "coefficients":[_arb_bounds(C[i,0],35) for i in range(N)],
        "explicit_candidate_errors_sq":candidate_errors,
        "optimal_coefficient_diagnostics":coeff_diagnostics,
        "scaled_mobius_power_taper_scan":scaled_power_scan,
        "scaled_mobius_dyadic_scan_m_over_16":dyadic_scan,
        "finite_N_only":True,
        "dnlimit_eq_zero_proved":False,
        "rh_proved":False,
    }

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--backend",choices=["mpmath","arb"],default="mpmath")
    ap.add_argument("--schedule",default="2,4,8,16,32,64")
    ap.add_argument("--dps",type=int,default=100)
    ap.add_argument("--jsonl",default="")
    args=ap.parse_args()
    records=[]
    for N in _schedule(args.schedule):
        rec=run_arb(N,args.dps) if args.backend=="arb" else run_mpmath(N,args.dps)
        records.append(rec)
        print(json.dumps(rec,sort_keys=True))
    if args.jsonl:
        with open(args.jsonl,"w",encoding="utf-8") as f:
            for rec in records:
                f.write(json.dumps(rec,sort_keys=True)+"\n")

if __name__=="__main__":
    main()
