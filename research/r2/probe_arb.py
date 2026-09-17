#!/usr/bin/env python3
import flint
from flint import arb,arb_mat,ctx
ctx.dps=80
print("python-flint",flint.__version__)
print("pi",arb.pi())
print("euler",arb.const_euler())
print("log2",arb(2).log())
A=arb_mat([[2,1],[1,2]])
B=arb_mat([[1],[0]])
X=A.solve(B,algorithm="precond")
print("solve",X)
print("residual",A*X-B)
assert (A*X).overlaps(B)
print("ARB_PROBE=GREEN")
