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
