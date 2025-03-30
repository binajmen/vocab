import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `create_adjective` query
/// defined in `./src/app/adjective/sql/create_adjective.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateAdjectiveRow {
  CreateAdjectiveRow(
    id: Uuid,
    positive: String,
    comparative: String,
    superlative: String,
  )
}

/// Runs the `create_adjective` query
/// defined in `./src/app/adjective/sql/create_adjective.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_adjective(db, arg_1, arg_2, arg_3) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use positive <- decode.field(1, decode.string)
    use comparative <- decode.field(2, decode.string)
    use superlative <- decode.field(3, decode.string)
    decode.success(
      CreateAdjectiveRow(id:, positive:, comparative:, superlative:),
    )
  }

  "with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('adjective')
    returning
      id
  )
insert into
  adjectives (id, positive, comparative, superlative)
select
  id,
  $1,
  $2,
  $3
from
  lexicon_insert
returning
  id,
  positive,
  comparative,
  superlative;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_adjectives` query
/// defined in `./src/app/adjective/sql/find_adjectives.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindAdjectivesRow {
  FindAdjectivesRow(
    id: Uuid,
    positive: String,
    comparative: String,
    superlative: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
  )
}

/// Runs the `find_adjectives` query
/// defined in `./src/app/adjective/sql/find_adjectives.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_adjectives(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use positive <- decode.field(1, decode.string)
    use comparative <- decode.field(2, decode.string)
    use superlative <- decode.field(3, decode.string)
    use created_at <- decode.field(4, pog.timestamp_decoder())
    use updated_at <- decode.field(5, pog.timestamp_decoder())
    decode.success(
      FindAdjectivesRow(
        id:,
        positive:,
        comparative:,
        superlative:,
        created_at:,
        updated_at:,
      ),
    )
  }

  "select
  *
from
  adjectives
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
