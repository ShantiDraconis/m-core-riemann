#!/usr/bin/env python3
"""
Independent, non-rigorous sanity test for the Vasyunin implementation.
The integral is truncated at T; the omitted positive tail is <= 1/T.
This is not a certificate and is never used to promote R2.
"""
import argparse
import mpmath as mp
from gram_engine import gram_mpmath,b_mpmath
mp.mp.dps=60

def frac(x):
    return x-mp.floor(x)

def truncated_gram(a,b,T):
    def f(t):
        if t==0:
            return mp.mpf(1)/(a*b)
        return frac(t/a)*frac(t/b)/(t*t)
    pts={mp.mpf(0),mp.mpf(T)}
    for n in range(1,int(T//a)+1):
        pts.add(mp.mpf(n*a))
    for n in range(1,int(T//b)+1):
        pts.add(mp.mpf(n*b))
    pts=sorted(pts)
    total=mp.mpf(0)
    for u,v in zip(pts[:-1],pts[1:]):
        total += mp.quad(f,[u,v])
    return total

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--T",type=int,default=200)
    args=ap.parse_args()
    for a,b in [(1,1),(1,2),(2,3),(2,4),(3,5)]:
        q=truncated_gram(a,b,args.T)
        g=gram_mpmath(a,b,60)
        tail=mp.mpf(1)/args.T
        ok=(g>=q-mp.mpf("1e-20")) and (g<=q+tail+mp.mpf("1e-12"))
        print(a,b,"quad",mp.nstr(q,25),"formula",mp.nstr(g,25),"tail<=",tail,"ok",ok)
        if not ok:
            raise SystemExit(1)
    assert abs(b_mpmath(1,60)-(1-mp.euler))<mp.mpf("1e-50")
    print("VASYUNIN_SANITY=GREEN")

if __name__=="__main__":
    main()
