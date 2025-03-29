import gleam/dynamic/decode
import gleam/json
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_verbs` query
/// defined in `./src/app/verb/sql/find_verbs.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindVerbsRow {
  FindVerbsRow(
    id: Uuid,
    infinitive: String,
    present: String,
    present_perfect: String,
    past: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
  )
}

/// Runs the `find_verbs` query
/// defined in `./src/app/verb/sql/find_verbs.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_verbs(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use infinitive <- decode.field(1, decode.string)
    use present <- decode.field(2, decode.string)
    use present_perfect <- decode.field(3, decode.string)
    use past <- decode.field(4, decode.string)
    use created_at <- decode.field(5, pog.timestamp_decoder())
    use updated_at <- decode.field(6, pog.timestamp_decoder())
    decode.success(
      FindVerbsRow(
        id:,
        infinitive:,
        present:,
        present_perfect:,
        past:,
        created_at:,
        updated_at:,
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

/// A row you get from running the `create_verb` query
/// defined in `./src/app/verb/sql/create_verb.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateVerbRow {
  CreateVerbRow(
    id: Uuid,
    infinitive: String,
    present: String,
    present_perfect: String,
    past: String,
  )
}

/// Runs the `create_verb` query
/// defined in `./src/app/verb/sql/create_verb.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_verb(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use infinitive <- decode.field(1, decode.string)
    use present <- decode.field(2, decode.string)
    use present_perfect <- decode.field(3, decode.string)
    use past <- decode.field(4, decode.string)
    decode.success(
      CreateVerbRow(id:, infinitive:, present:, present_perfect:, past:),
    )
  }

  "with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('verb')
    returning
      id
  )
insert into
  verbs (id, infinitive, present, present_perfect, past)
select
  id,
  $1,
  $2,
  $3,
  $4
from
  lexicon_insert
returning
  id,
  infinitive,
  present,
  present_perfect,
  past;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(json.to_string(arg_2)))
  |> pog.parameter(pog.text(json.to_string(arg_3)))
  |> pog.parameter(pog.text(json.to_string(arg_4)))
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
