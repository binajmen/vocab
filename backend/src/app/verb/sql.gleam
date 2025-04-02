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
    infinitive: String,
    present: String,
    simple_past: String,
    present_perfect: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
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
    use infinitive <- decode.field(1, decode.string)
    use present <- decode.field(2, decode.string)
    use simple_past <- decode.field(3, decode.string)
    use present_perfect <- decode.field(4, decode.string)
    use created_at <- decode.field(5, pog.timestamp_decoder())
    use updated_at <- decode.field(6, pog.timestamp_decoder())
    decode.success(
      FindVerbsRow(
        id:,
        infinitive:,
        present:,
        simple_past:,
        present_perfect:,
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

/// A row you get from running the `find_verbs_by_lang` query
/// defined in `./src/app/verb/sql/find_verbs_by_lang.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindVerbsByLangRow {
  FindVerbsByLangRow(
    id: Uuid,
    infinitive: String,
    present: String,
    simple_past: String,
    present_perfect: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
    translation: String,
  )
}

/// Runs the `find_verbs_by_lang` query
/// defined in `./src/app/verb/sql/find_verbs_by_lang.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_verbs_by_lang(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use infinitive <- decode.field(1, decode.string)
    use present <- decode.field(2, decode.string)
    use simple_past <- decode.field(3, decode.string)
    use present_perfect <- decode.field(4, decode.string)
    use created_at <- decode.field(5, pog.timestamp_decoder())
    use updated_at <- decode.field(6, pog.timestamp_decoder())
    use translation <- decode.field(7, decode.string)
    decode.success(
      FindVerbsByLangRow(
        id:,
        infinitive:,
        present:,
        simple_past:,
        present_perfect:,
        created_at:,
        updated_at:,
        translation:,
      ),
    )
  }

  "select
  v.*,
  t.translation as translation
from verbs as v
inner join translations as t on t.lexicon_id = v.id
where t.lang = $1
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
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
    infinitive: String,
    present: String,
    simple_past: String,
    present_perfect: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
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
    use infinitive <- decode.field(1, decode.string)
    use present <- decode.field(2, decode.string)
    use simple_past <- decode.field(3, decode.string)
    use present_perfect <- decode.field(4, decode.string)
    use created_at <- decode.field(5, pog.timestamp_decoder())
    use updated_at <- decode.field(6, pog.timestamp_decoder())
    decode.success(
      FindVerbRow(
        id:,
        infinitive:,
        present:,
        simple_past:,
        present_perfect:,
        created_at:,
        updated_at:,
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
  CreateVerbRow(
    id: Uuid,
    infinitive: String,
    present: String,
    simple_past: String,
    present_perfect: String,
  )
}

/// Runs the `create_verb` query
/// defined in `./src/app/verb/sql/create_verb.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_verb(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use infinitive <- decode.field(1, decode.string)
    use present <- decode.field(2, decode.string)
    use simple_past <- decode.field(3, decode.string)
    use present_perfect <- decode.field(4, decode.string)
    decode.success(
      CreateVerbRow(id:, infinitive:, present:, simple_past:, present_perfect:),
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
  verbs (id, infinitive, present, simple_past, present_perfect)
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
  simple_past,
  present_perfect
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(json.to_string(arg_2)))
  |> pog.parameter(pog.text(json.to_string(arg_3)))
  |> pog.parameter(pog.text(json.to_string(arg_4)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `update_verb` query
/// defined in `./src/app/verb/sql/update_verb.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.2 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type UpdateVerbRow {
  UpdateVerbRow(
    id: Uuid,
    infinitive: String,
    present: String,
    simple_past: String,
    present_perfect: String,
  )
}

/// Runs the `update_verb` query
/// defined in `./src/app/verb/sql/update_verb.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.2 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_verb(db, arg_1, arg_2, arg_3, arg_4, arg_5) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use infinitive <- decode.field(1, decode.string)
    use present <- decode.field(2, decode.string)
    use simple_past <- decode.field(3, decode.string)
    use present_perfect <- decode.field(4, decode.string)
    decode.success(
      UpdateVerbRow(id:, infinitive:, present:, simple_past:, present_perfect:),
    )
  }

  "update
  verbs
set
  infinitive = $2,
  present = $3,
  simple_past = $4,
  present_perfect = $5
where
  id = $1
returning
  id,
  infinitive,
  present,
  simple_past,
  present_perfect
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(json.to_string(arg_3)))
  |> pog.parameter(pog.text(json.to_string(arg_4)))
  |> pog.parameter(pog.text(json.to_string(arg_5)))
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
