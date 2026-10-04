import MCore.RH.Analytic.MellinTailPartial
import Mathlib.Analysis.PSeriesComplex
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics

namespace MCore.RH.R0

open Complex Filter Topology

/-- First boundary term in the telescoping formula tends to zero on Re(s)>1. -/
theorem tendsto_nat_cpow_one_sub
    (s : ℂ) (hs : 1 < s.re) :
    Tendsto
      (fun N : ℕ => (((N + 1 : ℕ) : ℂ) ^ (1 - s)))
      atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hreal : 0 < s.re - 1 := by linarith
  have hbase :
      Tendsto (fun N : ℕ => (((N + 1 : ℕ) : ℝ) ^ (-(s.re - 1))))
        atTop (𝓝 0) :=
    (tendsto_rpow_neg_atTop hreal).comp
      (tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop)
  convert hbase using 1
  funext N
  rw [Complex.norm_cpow_eq_rpow_re_of_pos (by positivity)]
  congr 1
  simp
  ring

/-- Second boundary term N*(N+1)^(-s) also tends to zero on Re(s)>1. -/
theorem tendsto_nat_mul_cpow_neg
    (s : ℂ) (hs : 1 < s.re) :
    Tendsto
      (fun N : ℕ =>
        ((N : ℕ) : ℂ) * (((N + 1 : ℕ) : ℂ) ^ (-s)))
      atTop (𝓝 0) := by
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hreal : 0 < s.re - 1 := by linarith
  have hmajor :
      Tendsto (fun N : ℕ => (((N + 1 : ℕ) : ℝ) ^ (-(s.re - 1))))
        atTop (𝓝 0) :=
    (tendsto_rpow_neg_atTop hreal).comp
      (tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop)
  refine squeeze_zero' (fun N => norm_nonneg _) hmajor ?_
  filter_upwards with N
  rw [norm_mul, Complex.norm_natCast, Complex.norm_cpow_eq_rpow_re_of_pos (by positivity)]
  simp only [neg_re]
  have hN : (N : ℝ) ≤ N + 1 := by linarith
  have hNp : 0 < (N + 1 : ℝ) := by positivity
  have hpow :
      ((N + 1 : ℝ) ^ (-(s.re - 1))) =
        (N + 1 : ℝ) * ((N + 1 : ℝ) ^ (-s.re)) := by
    rw [← Real.rpow_one (N + 1 : ℝ), ← Real.rpow_add hNp]
    congr 1
    ring
  rw [hpow]
  gcongr
  exact Real.rpow_nonneg _ _

/-- Partial sums of the zeta Dirichlet series converge to riemannZeta(s). -/
theorem tendsto_zeta_partial
    (s : ℂ) (hs : 1 < s.re) :
    Tendsto
      (fun N : ℕ =>
        ∑ n ∈ Finset.range N, 1 / (((n + 1 : ℕ) : ℂ) ^ s))
      atTop (𝓝 (riemannZeta s)) := by
  have hsum :
      Summable (fun n : ℕ => 1 / (((n + 1 : ℕ) : ℂ) ^ s)) := by
    rw [← summable_nat_add_iff 1]
    simpa using (Complex.summable_one_div_nat_cpow.mpr hs)
  have ht := hsum.hasSum.tendsto_sum_nat
  rw [← zeta_eq_tsum_one_div_nat_add_one_cpow hs]
  exact ht

/-- The complex block series has the expected zeta closed form for Re(s)>1. -/
theorem complexTailSeriesClosedForm_realized :
    ComplexTailSeriesClosedForm := by
  intro s hs
  have hs0 : s ≠ 0 := by
    intro h; subst s; norm_num at hs
  have hs1 : s ≠ 1 := by
    intro h; subst s; norm_num at hs
  have hpartial := complexTailPartial_formula
  have hlim1 := tendsto_nat_cpow_one_sub s hs
  have hlim2 := tendsto_nat_mul_cpow_neg s hs
  have hlim3 := tendsto_zeta_partial s hs
  have hcombo :
      Tendsto
        (fun N : ℕ => complexTailPartial N s)
        atTop
        (𝓝 (1 / (s - 1) - riemannZeta s / s)) := by
    apply Tendsto.congr' _
    · exact Eventually.of_forall (fun N => hpartial N s hs0 hs1)
    · convert
        ((hlim1.sub tendsto_const_nhds).div_const (1 - s)).add
          ((hlim2.sub hlim3).const_mul (1 / s)) using 1 <;> ring
  have hsum : Summable (fun n : ℕ => complexTailTerm (n + 1) s) := by
    rw [summable_iff_cauchySeq_finset]
    exact hcombo.cauchySeq
  exact tendsto_nhds_unique hsum.hasSum.tendsto_sum_nat hcombo

#print axioms MCore.RH.R0.complexTailSeriesClosedForm_realized

end MCore.RH.R0
