import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `create_lexicon` query
/// defined in `./src/app/lexicon/sql/create_lexicon.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateLexiconRow {
  CreateLexiconRow(id: Uuid, class: String)
}

/// Runs the `create_lexicon` query
/// defined in `./src/app/lexicon/sql/create_lexicon.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_lexicon(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use class <- decode.field(1, decode.string)
    decode.success(CreateLexiconRow(id:, class:))
  }

  "insert into
  lexicons (class)
values
  ($1)
returning
  id,
  class
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_lexicons` query
/// defined in `./src/app/lexicon/sql/find_lexicons.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindLexiconsRow {
  FindLexiconsRow(
    id: Uuid,
    class: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
  )
}

/// Runs the `find_lexicons` query
/// defined in `./src/app/lexicon/sql/find_lexicons.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_lexicons(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use class <- decode.field(1, decode.string)
    use created_at <- decode.field(2, pog.timestamp_decoder())
    use updated_at <- decode.field(3, pog.timestamp_decoder())
    decode.success(FindLexiconsRow(id:, class:, created_at:, updated_at:))
  }

  "select
  *
from
  lexicons;
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
