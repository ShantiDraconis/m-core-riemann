import MCore.RH.R0.VasyuninGCD

namespace MCore.RH.R0

/--
Once the coprime Vasyunin identity is supplied, the fully finite cotangent-sum
rate target is exactly the canonical uniform logarithmic DN producer.
-/
theorem finiteVasyuninRateTarget_iff_uniformLogDNBound_of_coprime
    (hcop : CoprimeVasyuninFormula) :
    FiniteVasyuninRateTarget ↔ ConcreteUniformLogDNBound := by
  have hV : VasyuninGramFormula :=
    vasyuninGramFormula_of_coprime hcop
  exact (finiteVasyuninRateTarget_iff_explicitGramRate hV).trans
    explicitGramRateTarget_iff_uniformLogDNBound

/--
Thus a finite Vasyunin rate certificate closes the terminal RH chain once the
classical coprime Gram identity is available.
-/
theorem terminal_of_finiteVasyuninRate
    (hcop : CoprimeVasyuninFormula)
    (hRate : FiniteVasyuninRateTarget) :
    RiemannTerminalCertifies := by
  have hUniform : ConcreteUniformLogDNBound :=
    (finiteVasyuninRateTarget_iff_uniformLogDNBound_of_coprime hcop).mp hRate
  exact terminal_of_concreteUniformLogDNBound hUniform

#print axioms MCore.RH.R0.finiteVasyuninRateTarget_iff_uniformLogDNBound_of_coprime
#print axioms MCore.RH.R0.terminal_of_finiteVasyuninRate

end MCore.RH.R0
