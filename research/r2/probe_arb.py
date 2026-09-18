#!/usr/bin/env python3
import flint
from flint import arb,arb_mat,ctx
from gram_engine import gram_arb
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

# Independent analytic diagonal anchor:
# G_aa = (log(2*pi)-EulerGamma)/a.
diag_const=(arb(2)*arb.pi()).log()-arb.const_euler()
for a in [1,2,7,64]:
    via_vasyunin=gram_arb(a,a,80)
    exact=diag_const/a
    print("diag",a,"gram",via_vasyunin,"exact",exact)
    assert via_vasyunin.overlaps(exact)
print("GRAM_DIAGONAL_IDENTITY_SANITY=GREEN")
print("ARB_PROBE=GREEN")
