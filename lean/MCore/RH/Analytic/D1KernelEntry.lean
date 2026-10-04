import MCore.RH.Analytic.MellinTailRight
import MCore.RH.Analytic.MellinTailContinuation

namespace MCore.RH.R0

/--
Focused kernel entrypoint for the D1 analytic lane.
It packages the already realized right-half-plane Abel identity and the
positive-half-plane Mellin continuation without introducing a hypothesis.
-/
theorem d1_kernel_entry_right :
    TailFormulaRight :=
  tailFormulaRight_realized

/--
The exact continued fractional-tail identity on Re(s)>0, away from the pole.
-/
theorem d1_kernel_entry_continuation :
    ∀ s : ℂ, 0 < s.re → s ≠ 1 →
      fractionalTailComplex s =
        1 / (s - 1) - riemannZeta s / s :=
  tailAnalyticContinuation_realized

/--
The Mellin analyticity producer itself, exposed for focused axiom auditing.
-/
theorem d1_kernel_entry_mellin :
    TailMellinAnalytic :=
  tailMellinAnalytic_realized

#print axioms MCore.RH.R0.d1_kernel_entry_right
#print axioms MCore.RH.R0.d1_kernel_entry_continuation
#print axioms MCore.RH.R0.d1_kernel_entry_mellin

end MCore.RH.R0
