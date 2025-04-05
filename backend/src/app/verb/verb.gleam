import app/verb/conjugation.{type Conjugation}
import gleam/dict
import gleam/dynamic/decode

pub type Verb {
  Verb(
    infinitive: String,
    present: Conjugation,
    simple_past: Conjugation,
    present_perfect: Conjugation,
    translations: dict.Dict(String, String),
  )
}

pub fn decoder() {
  use infinitive <- decode.field("infinitive", decode.string)
  use present <- decode.field("present", conjugation.decoder())
  use simple_past <- decode.field("simple_past", conjugation.decoder())
  use present_perfect <- decode.field("present_perfect", conjugation.decoder())
  use translations <- decode.field(
    "translations",
    decode.dict(decode.string, decode.string),
  )
  decode.success(Verb(
    infinitive,
    present,
    simple_past,
    present_perfect,
    translations,
  ))
}
