import gleam/dynamic/decode
import gleam/option.{type Option}

pub type Lexicon {
  Lexicon(id: String, name: String, tabs: Option(List(Tab)))
}

pub fn lexicon_decoder() {
  use id <- decode.field("id", decode.string)
  use name <- decode.field("name", decode.string)
  use tabs <- decode.field("tabs", decode.optional(decode.list(tab_decoder())))
  decode.success(Lexicon(id, name, tabs))
}

pub type Tab {
  Tab(name: Option(String), fields: List(Field))
}

fn tab_decoder() {
  use name <- decode.field("name", decode.optional(decode.string))
  use fields <- decode.optional_field(
    "fields",
    [],
    decode.list(field_decoder()),
  )
  decode.success(Tab(name, fields))
}

pub type Field =
  String

fn field_decoder() {
  decode.string
}
