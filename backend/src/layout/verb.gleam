import gleam/option.{Some}
import layout/grammar.{type Lexicon, type Tab, Lexicon}

pub type Verb {
  Verb(id: String, name: String, tabs: List(Tab))
}

pub fn to_verb(lexicon: Lexicon) -> Result(Verb, String) {
  case lexicon {
    Lexicon(id, name, Some(tabs)) -> Ok(Verb(id, name, tabs))
    _ -> Error("invalid verb format")
  }
}
