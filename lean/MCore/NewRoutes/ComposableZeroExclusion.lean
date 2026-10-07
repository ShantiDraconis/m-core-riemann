namespace MCore.NewRoutes
structure ComposableZeroExclusion where
  Scale : Type
  Certificate : Scale → Type
  compose : ∀ a b, Certificate a → Certificate b → Prop
  coversOffLine : Prop
  excludesZeros : Prop
end MCore.NewRoutes
