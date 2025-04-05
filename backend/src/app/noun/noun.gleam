import gleam/dict
import gleam/dynamic/decode

pub type Noun {
  Noun(
    article: String,
    singular: String,
    plural: String,
    translations: dict.Dict(String, String),
  )
}

pub fn decoder() {
  use article <- decode.field("article", decode.string)
  use singular <- decode.field("singular", decode.string)
  use plural <- decode.field("plural", decode.string)
  use translations <- decode.field(
    "translations",
    decode.dict(decode.string, decode.string),
  )
  decode.success(Noun(article, singular, plural, translations))
}
