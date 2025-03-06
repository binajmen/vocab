import gleam/option.{None}
import layout/grammar.{type Lexicon, Lexicon}

pub type Expression {
  Expression(id: String, name: String)
}

pub fn to_expression(lexicon: Lexicon) -> Result(Expression, String) {
  case lexicon {
    Lexicon(id, name, None) -> Ok(Expression(id, name))
    _ -> Error("invalid expression format")
  }
}
