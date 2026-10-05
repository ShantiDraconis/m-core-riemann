import MCore.RH.R0.ConcreteGramLogRate
import Mathlib.LinearAlgebra.Matrix.PosDef

open scoped BigOperators

namespace MCore.RH.R0

open MCore.RH.NB

/-- Concrete finite Gram matrix of the frozen generator family. -/
noncomputable def concreteGramMatrix (N : ℕ) : Matrix (Fin N) (Fin N) ℝ :=
  fun i j => @inner ℝ concreteNBData.H _ (concreteGeneratorFamily i) (concreteGeneratorFamily j)

/-- Concrete target vector of inner products with chi. -/
noncomputable def concreteTargetVector (N : ℕ) : Fin N → ℝ :=
  fun i => concreteNBData.targetEntry concreteGeneratorFamily i

@[simp]
theorem concreteGramMatrix_apply (N : ℕ) (i j : Fin N) :
    concreteGramMatrix N i j =
      concreteNBData.gramEntry concreteGeneratorFamily i j := by
  rfl

@[simp]
theorem concreteTargetVector_apply (N : ℕ) (i : Fin N) :
    concreteTargetVector N i =
      concreteNBData.targetEntry concreteGeneratorFamily i := by
  rfl

private theorem concreteGram_quadratic
    (N : ℕ) (x : Fin N → ℝ) :
    dotProduct x (concreteGramMatrix N *ᵥ x) =
      @inner ℝ concreteNBData.H _
        (∑ i : Fin N, x i • concreteGeneratorFamily i)
        (∑ i : Fin N, x i • concreteGeneratorFamily i) := by
  simp only [concreteGramMatrix, Matrix.mulVec, dotProduct, Finset.mul_sum,
    Finset.sum_mul, sum_inner, inner_sum, real_inner_smul_left,
    real_inner_smul_right]
  simp only [Finset.sum_mul, Finset.mul_sum]
  ring

/-- Every finite concrete Gram matrix is positive semidefinite. -/
theorem concreteGramMatrix_posSemidef (N : ℕ) :
    (concreteGramMatrix N).PosSemidef := by
  constructor
  · ext i j
    simp [concreteGramMatrix, real_inner_comm]
  · intro x
    rw [show star x = x by ext i; simp]
    rw [concreteGram_quadratic]
    exact real_inner_self_nonneg

/-- Positive definiteness is exactly finite linear independence of the generators. -/
theorem concreteGramMatrix_posDef_iff_linearIndependent (N : ℕ) :
    (concreteGramMatrix N).PosDef ↔
      LinearIndependent ℝ (fun i : Fin N => concreteGeneratorFamily i) := by
  rw [Fintype.linearIndependent_iff]
  constructor
  · intro h x hx
    by_contra hs
    have hq := h.2 x hx
    rw [show star x = x by ext i; simp] at hq
    rw [concreteGram_quadratic] at hq
    simp [hs] at hq
  · intro h
    refine ⟨(concreteGramMatrix_posSemidef N).1, ?_⟩
    intro x hx
    rw [show star x = x by ext i; simp]
    rw [concreteGram_quadratic]
    have hsum : (∑ i : Fin N, x i • concreteGeneratorFamily i) ≠ 0 := by
      exact mt (h x) hx
    exact real_inner_self_pos.mpr hsum

/-- Existing scalar normal equations are exactly the matrix equation G_N c = b_N. -/
theorem concrete_normal_equations_iff_mulVec
    (N : ℕ) (c : Fin N → ℝ) :
    (∀ j : Fin N,
      (∑ i : Fin N,
        c i * concreteNBData.gramEntry concreteGeneratorFamily i j) =
        concreteNBData.targetEntry concreteGeneratorFamily j) ↔
      concreteGramMatrix N *ᵥ c = concreteTargetVector N := by
  constructor
  · intro h
    funext j
    simpa [concreteGramMatrix, concreteTargetVector, Matrix.mulVec,
      dotProduct, mul_comm, real_inner_comm] using h j
  · intro h j
    have hj := congr_fun h j
    simpa [concreteGramMatrix, concreteTargetVector, Matrix.mulVec,
      dotProduct, mul_comm, real_inner_comm] using hj

/-- The canonical optimal coefficients solve the explicit concrete Gram system. -/
theorem optimalGramCoeff_mulVec (N : ℕ) :
    concreteGramMatrix N *ᵥ optimalGramCoeff N =
      concreteTargetVector N := by
  exact
    (concrete_normal_equations_iff_mulVec N (optimalGramCoeff N)).1
      (optimalGramCoeff_normal N)

#print axioms MCore.RH.R0.concreteGramMatrix_posSemidef
#print axioms MCore.RH.R0.concreteGramMatrix_posDef_iff_linearIndependent
#print axioms MCore.RH.R0.concrete_normal_equations_iff_mulVec
#print axioms MCore.RH.R0.optimalGramCoeff_mulVec

end MCore.RH.R0
