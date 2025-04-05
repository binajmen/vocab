import gleam/dynamic/decode
import gleam/json
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_verbs` query
/// defined in `./src/app/verb/sql/find_verbs.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindVerbsRow {
  FindVerbsRow(
    id: Uuid,
    lexicon_id: Uuid,
    infinitive: String,
    present: String,
    simple_past: String,
    present_perfect: String,
    translations: String,
  )
}

/// Runs the `find_verbs` query
/// defined in `./src/app/verb/sql/find_verbs.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_verbs(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use lexicon_id <- decode.field(1, uuid_decoder())
    use infinitive <- decode.field(2, decode.string)
    use present <- decode.field(3, decode.string)
    use simple_past <- decode.field(4, decode.string)
    use present_perfect <- decode.field(5, decode.string)
    use translations <- decode.field(6, decode.string)
    decode.success(
      FindVerbsRow(
        id:,
        lexicon_id:,
        infinitive:,
        present:,
        simple_past:,
        present_perfect:,
        translations:,
      ),
    )
  }

  "select
  *
from
  verbs
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_verb` query
/// defined in `./src/app/verb/sql/find_verb.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindVerbRow {
  FindVerbRow(
    id: Uuid,
    lexicon_id: Uuid,
    infinitive: String,
    present: String,
    simple_past: String,
    present_perfect: String,
    translations: String,
  )
}

/// Runs the `find_verb` query
/// defined in `./src/app/verb/sql/find_verb.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_verb(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use lexicon_id <- decode.field(1, uuid_decoder())
    use infinitive <- decode.field(2, decode.string)
    use present <- decode.field(3, decode.string)
    use simple_past <- decode.field(4, decode.string)
    use present_perfect <- decode.field(5, decode.string)
    use translations <- decode.field(6, decode.string)
    decode.success(
      FindVerbRow(
        id:,
        lexicon_id:,
        infinitive:,
        present:,
        simple_past:,
        present_perfect:,
        translations:,
      ),
    )
  }

  "select * from verbs where id = $1;
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `create_verb` query
/// defined in `./src/app/verb/sql/create_verb.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateVerbRow {
  CreateVerbRow(id: Uuid)
}

/// Runs the `create_verb` query
/// defined in `./src/app/verb/sql/create_verb.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_verb(db, arg_1, arg_2, arg_3, arg_4, arg_5) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    decode.success(CreateVerbRow(id:))
  }

  "with
  lexicon_insert as (
    insert into
      lexicon (category, concept)
    values
      ('verb', $1)
    returning
      id
  )
insert into
  verbs (id, infinitive, present, simple_past, present_perfect, translations)
select
  id,
  $1,
  $2,
  $3,
  $4,
  $5
from
  lexicon_insert
returning
  id;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(json.to_string(arg_2)))
  |> pog.parameter(pog.text(json.to_string(arg_3)))
  |> pog.parameter(pog.text(json.to_string(arg_4)))
  |> pog.parameter(pog.text(json.to_string(arg_5)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `update_verb` query
/// defined in `./src/app/verb/sql/update_verb.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_verb(db, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "update
  verbs
set
  infinitive = $2,
  present = $3,
  simple_past = $4,
  present_perfect = $5,
  translations = $6
where
  id = $1
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(json.to_string(arg_3)))
  |> pog.parameter(pog.text(json.to_string(arg_4)))
  |> pog.parameter(pog.text(json.to_string(arg_5)))
  |> pog.parameter(pog.text(json.to_string(arg_6)))
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
