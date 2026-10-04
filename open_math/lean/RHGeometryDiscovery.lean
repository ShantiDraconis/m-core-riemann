import MCore.RH.Experimental.GeometryAnsatz
import MCore.RH.R0.LinearIndependentReduction
import Lean

open scoped BigOperators
open Lean Elab Tactic

elab "dump_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-GEOM-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_geom_gap_{name.getString}.txt" body

namespace MCore.RH.Experimental

open MCore.RH.NB
open MCore.RH.R0

/- Geometry discovery is intentionally RED until an actual coefficient map is supplied. -/

def ScalarParamAnsatz : GeometryAnsatz where
  Param := ℝ
  coeff := fun N p i => p / ((i.1 + 1 : ℕ) : ℝ)

def PairParamAnsatz : GeometryAnsatz where
  Param := ℝ × ℝ
  coeff := fun N p i =>
    p.1 / ((i.1 + 1 : ℕ) : ℝ) +
    p.2 / (((i.1 + 1 : ℕ) : ℝ) ^ 2)

/-- Square/cube/sphere/etc are labels until tied to a genuine ansatz. -/
def squareAnsatz : GeometryAnsatz := PairParamAnsatz
def cubeAnsatz : GeometryAnsatz := PairParamAnsatz
def sphereAnsatz : GeometryAnsatz := ScalarParamAnsatz
def cylinderAnsatz : GeometryAnsatz := PairParamAnsatz
def coneAnsatz : GeometryAnsatz := PairParamAnsatz
def doubleConeAnsatz : GeometryAnsatz := PairParamAnsatz
def tripleConeAnsatz : GeometryAnsatz := PairParamAnsatz
def torusAnsatz : GeometryAnsatz := PairParamAnsatz

theorem DISCOVER_square_normal : GeometryNormalCompatible squareAnsatz := by
  unfold GeometryNormalCompatible
  intro N
  dump_gap "SQUARE_NORMAL_COMPATIBILITY"
  exact ?_

theorem DISCOVER_sphere_normal : GeometryNormalCompatible sphereAnsatz := by
  unfold GeometryNormalCompatible
  intro N
  dump_gap "SPHERE_NORMAL_COMPATIBILITY"
  exact ?_

theorem DISCOVER_cone_normal : GeometryNormalCompatible coneAnsatz := by
  unfold GeometryNormalCompatible
  intro N
  dump_gap "CONE_NORMAL_COMPATIBILITY"
  exact ?_

theorem DISCOVER_torus_normal : GeometryNormalCompatible torusAnsatz := by
  unfold GeometryNormalCompatible
  intro N
  dump_gap "TORUS_NORMAL_COMPATIBILITY"
  exact ?_

def GeometryZeroWitnessCompatibility (G : GeometryAnsatz) : Prop :=
  ∀ ρ : ℂ, riemannZeta ρ = 0 → 1 / 2 < ρ.re →
    ∃ N : ℕ, ∃ p : G.Param,
      G.errorSq N p > 0

theorem DISCOVER_geometry_zero_relation (G : GeometryAnsatz) :
    GeometryZeroWitnessCompatibility G := by
  unfold GeometryZeroWitnessCompatibility
  intro ρ hz hre
  dump_gap "GEOMETRY_ZERO_RELATION"
  exact ?_

theorem DISCOVER_geometry_log_rate (G : GeometryAnsatz) :
    Nonempty (GeometryLogCertificate G) := by
  dump_gap "GEOMETRY_LOG_RATE"
  exact ?_

end MCore.RH.Experimental
