import gleam/dict
import gleam/dynamic/decode

pub type Adjective {
  Adjective(
    id: String,
    positive: String,
    comparative: String,
    superlative: String,
    translations: dict.Dict(String, String),
  )
}

pub fn decoder() {
  use positive <- decode.field("positive", decode.string)
  use comparative <- decode.field("comparative", decode.string)
  use superlative <- decode.field("superlative", decode.string)
  use translations <- decode.field(
    "translations",
    decode.dict(decode.string, decode.string),
  )
  decode.success(Adjective("", positive, comparative, superlative, translations))
}
