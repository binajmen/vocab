pub type Class {
  Noun
  Verb
  Adjective
  Adverb
  Pronoun
  Preposition
  Conjunction
  Interjection
}

pub type Lexicon {
  Lexicon(id: String, class: Class)
}
