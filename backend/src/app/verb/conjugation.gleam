import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleam/result

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

pub fn decoder() {
  use ich <- decode.field("ich", decode.string)
  use du <- decode.field("du", decode.string)
  use er_sie_es <- decode.field("er_sie_es", decode.string)
  use wir <- decode.field("wir", decode.string)
  use ihr <- decode.field("ihr", decode.string)
  use sie <- decode.field("sie", decode.string)
  decode.success(Conjugation(ich, du, er_sie_es, wir, ihr, sie))
}

pub fn to_dict(conjugation: String) {
  conjugation
  |> json.parse(decode.dict(decode.string, decode.string))
  |> result.unwrap(dict.new())
}

pub fn to_json(conjugation: Conjugation) {
  json.object([
    #("ich", json.string(conjugation.ich)),
    #("du", json.string(conjugation.du)),
    #("er_sie_es", json.string(conjugation.er_sie_es)),
    #("wir", json.string(conjugation.wir)),
    #("ihr", json.string(conjugation.ihr)),
    #("sie", json.string(conjugation.sie)),
  ])
}
