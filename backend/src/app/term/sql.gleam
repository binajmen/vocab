import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `create_term` query
/// defined in `./src/app/term/sql/create_term.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateTermRow {
  CreateTermRow(id: Uuid, term: String)
}

/// Runs the `create_term` query
/// defined in `./src/app/term/sql/create_term.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_term(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use term <- decode.field(1, decode.string)
    decode.success(CreateTermRow(id:, term:))
  }

  "with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('term')
    returning
      id
  )
insert into
  terms (id, term)
select
  id,
  $1
from
  lexicon_insert
returning
  id,
  term
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_terms` query
/// defined in `./src/app/term/sql/find_terms.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindTermsRow {
  FindTermsRow(
    id: Uuid,
    term: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
  )
}

/// Runs the `find_terms` query
/// defined in `./src/app/term/sql/find_terms.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_terms(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use term <- decode.field(1, decode.string)
    use created_at <- decode.field(2, pog.timestamp_decoder())
    use updated_at <- decode.field(3, pog.timestamp_decoder())
    decode.success(FindTermsRow(id:, term:, created_at:, updated_at:))
  }

  "select
	*
from
	terms
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
