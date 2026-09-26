import MCore.RH.R2.BackwardDenseEndpoint
import Mathlib.Data.Finset.Basic

namespace MCore.RH.R2

noncomputable section

/-- One simultaneous state ("petal") of the weighted modular sum.
    d is the gcd/dyadic scale; u,v are the coprime modular coordinates. -/
structure SNState where
  d : ℕ
  u : ℕ
  v : ℕ
deriving DecidableEq, Repr

/-- Semantic admissibility of a petal. FAR is supplied separately because it
    belongs to the frozen geometric decomposition, not to the bare state type. -/
def SNState.Admissible (s : SNState) : Prop :=
  0 < s.d ∧ 0 < s.u ∧ 0 < s.v ∧ Nat.Coprime s.u s.v

/-- Data needed to instantiate the concrete weighted modular bilinear object.
    petals N is the finite FAR support at scale N. -/
structure MultistateSNData where
  petals : ℕ → Finset SNState
  coeff : ℕ → ℕ → ℝ
  vasyunin : ℕ → ℕ → ℝ

/-- One petal contribution:
      log(N+2)/d * c_{N,du} c_{N,dv} * (V(v,u)+V(u,v))/(uv).
    The harmless +2 only avoids log 0 at tiny indices; an exact project
    instantiation may replace the scale normalization by its frozen convention. -/
def MultistateSNData.petalTerm
    (D : MultistateSNData) (N : ℕ) (s : SNState) : ℝ :=
  Real.log ((N : ℝ) + 2) *
    (1 / (s.d : ℝ)) *
    D.coeff N (s.d * s.u) *
    D.coeff N (s.d * s.v) *
    ((D.vasyunin s.v s.u + D.vasyunin s.u s.v) /
      ((s.u : ℝ) * (s.v : ℝ)))

/-- The multistate number S_N: a single real number obtained by summing all
    simultaneously active d/u/v petals. Each d may be read as one rose of the
    bouquet; the full number is their finite superposition. -/
def MultistateSNData.S (D : MultistateSNData) (N : ℕ) : ℝ :=
  ∑ s in D.petals N, D.petalTerm N s

/-- The unique material gap in the weighted-modular lane:
    an eventual absolute majorant for S_N that vanishes. -/
def WeightedModularBilinearDecay (D : MultistateSNData) : Prop :=
  ∃ eps : ℕ → ℝ,
    (∀ᶠ N : ℕ in Filter.atTop, |D.S N| ≤ eps N) ∧
    Filter.Tendsto eps Filter.atTop (nhds 0)

/-- Formal theorem version of WEIGHTED_MODULAR_BILINEAR_DECAY:
    the gap certificate forces the multistate number itself to vanish. -/
theorem kfar_vanishes_of_weighted_modular_bilinear_decay
    (D : MultistateSNData)
    (hDecay : WeightedModularBilinearDecay D) :
    Filter.Tendsto D.S Filter.atTop (nhds 0) := by
  rcases hDecay with ⟨eps, hupper, heps⟩
  rw [tendsto_zero_iff_abs_tendsto_zero]
  exact squeeze_zero'
    (Filter.Eventually.of_forall fun N => abs_nonneg (D.S N))
    hupper
    heps

/-- Exact bridge shape from weighted modular vanishing into the already-frozen
    R2 endpoint. This is a type, not an assumed theorem. -/
def WeightedModularToOpenBridge (D : MultistateSNData) : Prop :=
  Filter.Tendsto D.S Filter.atTop (nhds 0) → OpenBridge

/-- Once the frozen arithmetic identity/transport bridge is supplied, the
    weighted modular decay certificate closes the R2 internal OPEN_MATH gate. -/
theorem openBridge_of_weighted_modular_bilinear_decay
    (D : MultistateSNData)
    (hTransport : WeightedModularToOpenBridge D)
    (hDecay : WeightedModularBilinearDecay D) :
    OpenBridge :=
  hTransport (kfar_vanishes_of_weighted_modular_bilinear_decay D hDecay)

/-- The two tensioned obligations are explicit:
    (1) transport the exact S_N object to the frozen K_far/DN endpoint;
    (2) prove its unconditional weighted modular decay. -/
structure TensionedSNClosureCertificate (D : MultistateSNData) where
  transport : WeightedModularToOpenBridge D
  decay : WeightedModularBilinearDecay D

theorem tensioned_sn_certificate_closes_open_math
    (D : MultistateSNData)
    (C : TensionedSNClosureCertificate D) :
    OpenBridge :=
  openBridge_of_weighted_modular_bilinear_decay D C.transport C.decay

/-- Fail-closed marker: no inhabitant of the mathematical producer is
    manufactured by this file. -/
def weightedModularBilinearDecayClosed : Bool := false

theorem weighted_modular_bilinear_decay_still_open :
    weightedModularBilinearDecayClosed = false := by
  rfl

#print axioms MCore.RH.R2.kfar_vanishes_of_weighted_modular_bilinear_decay
#print axioms MCore.RH.R2.openBridge_of_weighted_modular_bilinear_decay
#print axioms MCore.RH.R2.tensioned_sn_certificate_closes_open_math
#print axioms MCore.RH.R2.weighted_modular_bilinear_decay_still_open

end
end MCore.RH.R2
