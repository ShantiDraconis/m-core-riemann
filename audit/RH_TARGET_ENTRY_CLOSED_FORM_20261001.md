# RH concrete target-entry closed form

Status: ANALYTIC_DERIVATION_READY_FOR_KERNELIZATION

This note contains no RH hypothesis, no DNLimit assumption, no finite-span
density assumption, and no endpoint-equivalent argument.

For the concrete generator index
m=n+1>=1 and rho_n(x)=fract(1/(m x)),
the target Gram vector entry is

b_n = <chi,rho_n> = integral_0^1 fract(1/(m x)) dx.

Use u=1/(m x), dx=-du/(m u^2). Then

b_n = (1/m) integral_{1/m}^infinity {u}/u^2 du.

On 1/m <= u < 1, {u}=u, hence this part is log m.

For each integer k>=1, on [k,k+1),
{u}=u-k, so

integral_k^{k+1} {u}/u^2 du
= log((k+1)/k) - 1/(k+1).

The partial sum to N is

sum_{k=1}^N [log((k+1)/k)-1/(k+1)]
= log(N+1)-H_{N+1}+1.

By H_{N+1}-log(N+1) -> gamma, the tail equals 1-gamma.

Therefore

b_n = (log(n+1)+1-gamma)/(n+1).

Kernelization target (after adapting casts/indexing and confirming the Mathlib
Euler-gamma constant name):

theorem concrete_targetEntry_closed_form (n : Nat) :
  concreteNBData.targetEntry concreteGeneratorFamily n =
    (Real.log (n + 1) + 1 - Real.eulerGamma) / (n + 1)

This theorem is strictly upstream of the open RH residual. It computes an
input to the Gram system; it does not assume or imply RH by itself.

With b_n explicit, the remaining finite-dimensional problem becomes

G_N c_N = b_N,
1 - b_N^T c_N <= K/log(N+2).

The remaining genuinely hard analytic object is therefore the Gram matrix
entry G_ij=<rho_i,rho_j> and a uniform bound on the resulting optimal
quadratic form.
