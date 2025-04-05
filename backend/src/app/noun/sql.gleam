import gleam/dynamic/decode
import gleam/json
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_noun` query
/// defined in `./src/app/noun/sql/find_noun.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindNounRow {
  FindNounRow(
    id: Uuid,
    lexicon_id: Uuid,
    article: String,
    singular: String,
    plural: String,
    translations: String,
  )
}

/// Runs the `find_noun` query
/// defined in `./src/app/noun/sql/find_noun.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_noun(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use lexicon_id <- decode.field(1, uuid_decoder())
    use article <- decode.field(2, decode.string)
    use singular <- decode.field(3, decode.string)
    use plural <- decode.field(4, decode.string)
    use translations <- decode.field(5, decode.string)
    decode.success(
      FindNounRow(id:, lexicon_id:, article:, singular:, plural:, translations:),
    )
  }

  "select
  *
from
  nouns
where
  id = $1;
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `update_noun` query
/// defined in `./src/app/noun/sql/update_noun.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_noun(db, arg_1, arg_2, arg_3, arg_4, arg_5) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "update
  nouns
set
  article = $2,
  singular = $3,
  plural = $4,
  translations = $5
where
  id = $1
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.parameter(pog.text(json.to_string(arg_5)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `create_noun` query
/// defined in `./src/app/noun/sql/create_noun.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateNounRow {
  CreateNounRow(id: Uuid)
}

/// Runs the `create_noun` query
/// defined in `./src/app/noun/sql/create_noun.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_noun(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    decode.success(CreateNounRow(id:))
  }

  "with
  lexicon_insert as (
    insert into
      lexicon(category, concept)
    values
      ('noun', $2)
    returning
      id
  )
insert into
  nouns (id, article, singular, plural, translations)
select
  id,
  $1,
  $2,
  $3,
  $4
from
  lexicon_insert
returning
  id;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(json.to_string(arg_4)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_nouns` query
/// defined in `./src/app/noun/sql/find_nouns.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindNounsRow {
  FindNounsRow(
    id: Uuid,
    lexicon_id: Uuid,
    article: String,
    singular: String,
    plural: String,
    translations: String,
  )
}

/// Runs the `find_nouns` query
/// defined in `./src/app/noun/sql/find_nouns.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_nouns(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use lexicon_id <- decode.field(1, uuid_decoder())
    use article <- decode.field(2, decode.string)
    use singular <- decode.field(3, decode.string)
    use plural <- decode.field(4, decode.string)
    use translations <- decode.field(5, decode.string)
    decode.success(
      FindNounsRow(id:, lexicon_id:, article:, singular:, plural:, translations:,
      ),
    )
  }

  "select
	n.*
from
	nouns n
"
  |> pog.query
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
