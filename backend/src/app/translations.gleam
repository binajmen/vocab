import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/result

pub type Translations =
  dict.Dict(String, String)

pub fn to_dict(translations: String) {
  translations
  |> json.parse(decode.dict(decode.string, decode.string))
  |> result.unwrap(dict.new())
}

pub fn to_json(translations: Translations) {
  todo
}
