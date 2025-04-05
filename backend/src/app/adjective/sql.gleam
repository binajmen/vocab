import gleam/dynamic/decode
import gleam/json
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `create_adjective` query
/// defined in `./src/app/adjective/sql/create_adjective.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateAdjectiveRow {
  CreateAdjectiveRow(id: Uuid)
}

/// Runs the `create_adjective` query
/// defined in `./src/app/adjective/sql/create_adjective.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_adjective(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    decode.success(CreateAdjectiveRow(id:))
  }

  "with
  lexicon_insert as (
    insert into
      lexicon (category, concept)
    values
      ('adjective', $1)
    returning
      id
  )
insert into
  adjectives (id, positive, comparative, superlative, translations)
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

/// A row you get from running the `find_adjectives` query
/// defined in `./src/app/adjective/sql/find_adjectives.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindAdjectivesRow {
  FindAdjectivesRow(
    id: Uuid,
    lexicon_id: Uuid,
    positive: String,
    comparative: String,
    superlative: String,
    translations: String,
  )
}

/// Runs the `find_adjectives` query
/// defined in `./src/app/adjective/sql/find_adjectives.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_adjectives(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use lexicon_id <- decode.field(1, uuid_decoder())
    use positive <- decode.field(2, decode.string)
    use comparative <- decode.field(3, decode.string)
    use superlative <- decode.field(4, decode.string)
    use translations <- decode.field(5, decode.string)
    decode.success(
      FindAdjectivesRow(
        id:,
        lexicon_id:,
        positive:,
        comparative:,
        superlative:,
        translations:,
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
