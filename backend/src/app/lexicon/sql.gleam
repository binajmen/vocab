import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_lexicons` query
/// defined in `./src/app/lexicon/sql/find_lexicons.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindLexiconsRow {
  FindLexiconsRow(id: Uuid, category: String, concept: String)
}

/// Runs the `find_lexicons` query
/// defined in `./src/app/lexicon/sql/find_lexicons.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_lexicons(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use category <- decode.field(1, decode.string)
    use concept <- decode.field(2, decode.string)
    decode.success(FindLexiconsRow(id:, category:, concept:))
  }

  "select
  *
from
  lexicon;
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
