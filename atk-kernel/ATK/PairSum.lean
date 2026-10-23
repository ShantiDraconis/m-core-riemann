import Mathlib

/-!
# ATK — PairSum (o 1/2 como evitar contagem dupla de pares)

Formaliza a identidade discutida na secao sobre Beal: para uma funcao
simetrica `f`, a soma sobre os pares nao ordenados `{i,j}` (com `i≠j`)
e exatamente a metade da soma sobre todos os pares ordenados `(i,j)` com
`i≠j`. Aqui no caso concreto de tres indices — generaliza-se, mas a versao
de tres ja carrega o conteudo algebrico completo do porque o `1/2`
aparece: ele cancela a dupla contagem de cada par, nada mais.

Isso NAO prova nada sobre a conjectura de Beal; e a identidade combinatoria
elementar que o proprio texto discutido ja reconhecia como correta e sem
implicacao aritmetica sobre a conjectura.
-/

namespace ATK.PairSum

variable {β : Type*} [Field β]

/-- Para tres indices e uma funcao simetrica `f`, a soma sobre os tres
    pares nao ordenados e exatamente a metade da soma sobre os seis pares
    ordenados correspondentes. -/
theorem pair_sum_symmetric_three (f : ℕ → ℕ → β) (hsymm : ∀ x y, f x y = f y x)
    (a b c : ℕ) :
    f a b + f a c + f b c =
      (f a b + f b a + f a c + f c a + f b c + f c b) / 2 := by
  have h1 : f b a = f a b := (hsymm a b).symm
  have h2 : f c a = f a c := (hsymm a c).symm
  have h3 : f c b = f b c := (hsymm b c).symm
  rw [h1, h2, h3]
  ring

end ATK.PairSum

#print axioms ATK.PairSum.pair_sum_symmetric_three
