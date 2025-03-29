import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_translations` query
/// defined in `./src/app/translation/sql/find_translations.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindTranslationsRow {
  FindTranslationsRow(
    id: Uuid,
    lexicon_id: Uuid,
    translation: String,
    lang: String,
  )
}

/// Runs the `find_translations` query
/// defined in `./src/app/translation/sql/find_translations.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_translations(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use lexicon_id <- decode.field(1, uuid_decoder())
    use translation <- decode.field(2, decode.string)
    use lang <- decode.field(3, decode.string)
    decode.success(FindTranslationsRow(id:, lexicon_id:, translation:, lang:))
  }

  "select
	*
from
	translations
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `create_translation` query
/// defined in `./src/app/translation/sql/create_translation.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateTranslationRow {
  CreateTranslationRow(
    id: Uuid,
    lexicon_id: Uuid,
    translation: String,
    lang: String,
  )
}

/// Runs the `create_translation` query
/// defined in `./src/app/translation/sql/create_translation.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_translation(db, arg_1, arg_2, arg_3) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use lexicon_id <- decode.field(1, uuid_decoder())
    use translation <- decode.field(2, decode.string)
    use lang <- decode.field(3, decode.string)
    decode.success(CreateTranslationRow(id:, lexicon_id:, translation:, lang:))
  }

  "insert into
  translations (lexicon_id, translation, lang)
values
  ($1, $2, $3)
returning
  id,
  lexicon_id,
  translation,
  lang
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

// --- Encoding/decoding utils -------------------------------------------------

/// A decoder to decode `Uuid`s coming from a Postgres query.
///
fn uuid_decoder() {
  use bit_array <- decode.then(decode.bit_array)
  case uuid.from_bit_array(bit_array) {
    Ok(uuid) -> decode.success(uuid)
    Error(_) -> decode.failure(uuid.v7(), "uuid")
  }
}
