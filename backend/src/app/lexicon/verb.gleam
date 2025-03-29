pub type Conjugation {
  Conjugation(
    ich: String,
    du: String,
    er_sie_es: String,
    wir: String,
    ihr: String,
    sie: String,
  )
}

pub type Verb {
  Verb(
    infinitive: String,
    present: Conjugation,
    present_perfect: Conjugation,
    past: Conjugation,
  )
}
