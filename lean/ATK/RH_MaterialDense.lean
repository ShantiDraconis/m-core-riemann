import MCore.Material.Closure

/-! RH dense integration of the existing material interface.
The terminal bound is *not* asserted without a concrete proof.
Original source blob: 197dd3d32059a231188eea65e61f517005f40493.
-/
namespace ATK.RH

abbrev DNBound (DN : Nat → Real) : Prop :=
  MCore.Material.ConcreteUniformLogDNBound DN

/-- A genuinely supplied RHClosure yields the corresponding bound. -/
theorem from_concrete_closure {DN : Nat → Real}
    (h : MCore.Material.RHClosure DN) : DNBound DN :=
  MCore.Material.closure_produces_bound h

/-- Unpack the concrete witness rather than claiming one exists. -/
theorem bound_has_witness {DN : Nat → Real}
    (h : DNBound DN) : Nonempty (MCore.Material.RHClosure DN) := h

end ATK.RH

#print axioms ATK.RH.from_concrete_closure
#print axioms ATK.RH.bound_has_witness
