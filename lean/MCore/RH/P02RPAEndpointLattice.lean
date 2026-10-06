import MCore.RH.P02RPADualCertificate

namespace MCore

/-!
# RPA endpoint lattice

Raw states retain OPEN/CLOSED multiplicities. Canonical states quotient by
idempotence, yielding exactly four endpoint configurations.
-/

structure RPARawMultiplicity where
  openCount : Nat
  closedCount : Nat
  deriving DecidableEq, Repr

def rawEmpty : RPARawMultiplicity := ⟨0, 0⟩
def rawOpen : RPARawMultiplicity := ⟨1, 0⟩
def rawClosed : RPARawMultiplicity := ⟨0, 1⟩
def rawDual : RPARawMultiplicity := ⟨1, 1⟩

def rawAdd (a b : RPARawMultiplicity) : RPARawMultiplicity :=
  ⟨a.openCount + b.openCount, a.closedCount + b.closedCount⟩

theorem raw_open_plus_open :
    rawAdd rawOpen rawOpen = ⟨2, 0⟩ := rfl

theorem raw_closed_plus_closed :
    rawAdd rawClosed rawClosed = ⟨0, 2⟩ := rfl

theorem raw_open_plus_closed :
    rawAdd rawOpen rawClosed = rawDual := rfl

inductive RPACanonicalState
  | empty
  | open
  | closed
  | full
  deriving DecidableEq, Repr

def canonicalize (r : RPARawMultiplicity) : RPACanonicalState :=
  match decide (r.openCount = 0), decide (r.closedCount = 0) with
  | true,  true  => .empty
  | false, true  => .open
  | true,  false => .closed
  | false, false => .full

theorem canonicalize_empty :
    canonicalize rawEmpty = .empty := by
  native_decide

theorem canonicalize_open :
    canonicalize rawOpen = .open := by
  native_decide

theorem canonicalize_closed :
    canonicalize rawClosed = .closed := by
  native_decide

theorem canonicalize_dual :
    canonicalize rawDual = .full := by
  native_decide

theorem canonicalize_open_idempotent :
    canonicalize (rawAdd rawOpen rawOpen) = canonicalize rawOpen := by
  native_decide

theorem canonicalize_closed_idempotent :
    canonicalize (rawAdd rawClosed rawClosed) = canonicalize rawClosed := by
  native_decide

def canonicalJoin : RPACanonicalState → RPACanonicalState → RPACanonicalState
  | .empty, x => x
  | x, .empty => x
  | .open, .open => .open
  | .closed, .closed => .closed
  | .open, .closed => .full
  | .closed, .open => .full
  | .full, _ => .full
  | _, .full => .full

theorem canonical_open_idem :
    canonicalJoin .open .open = .open := rfl

theorem canonical_closed_idem :
    canonicalJoin .closed .closed = .closed := rfl

theorem canonical_open_closed_full :
    canonicalJoin .open .closed = .full := rfl

theorem canonical_full_absorbing_left (x : RPACanonicalState) :
    canonicalJoin .full x = .full := by
  cases x <;> rfl

theorem canonical_full_absorbing_right (x : RPACanonicalState) :
    canonicalJoin x .full = .full := by
  cases x <;> rfl

abbrev RPAFull : Prop := DUAL_ENDPOINT_STATE

theorem full_is_dual_endpoint_state :
    RPAFull ↔ DUAL_ENDPOINT_STATE := Iff.rfl

theorem full_is_math :
    RPAFull ↔ RPAMath := Iff.rfl

theorem full_is_final_root :
    RPAFull ↔ RPAFinalRoot := Iff.rfl

theorem full_is_global_external_certificate :
    RPAFull ↔ RPAGlobalExternalCertificate := Iff.rfl

theorem full_chain_exact :
    RPAFull ↔
      (DUAL_ENDPOINT_STATE ∧
       RPAMath ∧
       RPAFinalRoot ∧
       RPAGlobalExternalCertificate) := by
  constructor
  · intro h
    exact ⟨h, h, h, h⟩
  · rintro ⟨h, _, _, _⟩
    exact h

end MCore
