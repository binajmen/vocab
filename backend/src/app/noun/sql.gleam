import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_noun` query
/// defined in `./src/app/noun/sql/find_noun.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindNounRow {
  FindNounRow(
    id: Uuid,
    article: String,
    singular: String,
    plural: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
  )
}

/// Runs the `find_noun` query
/// defined in `./src/app/noun/sql/find_noun.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_noun(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use article <- decode.field(1, decode.string)
    use singular <- decode.field(2, decode.string)
    use plural <- decode.field(3, decode.string)
    use created_at <- decode.field(4, pog.timestamp_decoder())
    use updated_at <- decode.field(5, pog.timestamp_decoder())
    decode.success(
      FindNounRow(id:, article:, singular:, plural:, created_at:, updated_at:),
    )
  }

  "select * from nouns where id = $1;
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `update_noun` query
/// defined in `./src/app/noun/sql/update_noun.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type UpdateNounRow {
  UpdateNounRow(id: Uuid, article: String, singular: String, plural: String)
}

/// Runs the `update_noun` query
/// defined in `./src/app/noun/sql/update_noun.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_noun(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use article <- decode.field(1, decode.string)
    use singular <- decode.field(2, decode.string)
    use plural <- decode.field(3, decode.string)
    decode.success(UpdateNounRow(id:, article:, singular:, plural:))
  }

  "update
  nouns
set
  article = $2,
  singular = $3,
  plural = $4
where
  id = $1
returning
  id,
  article,
  singular,
  plural
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `create_noun` query
/// defined in `./src/app/noun/sql/create_noun.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateNounRow {
  CreateNounRow(id: Uuid, article: String, singular: String, plural: String)
}

/// Runs the `create_noun` query
/// defined in `./src/app/noun/sql/create_noun.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_noun(db, arg_1, arg_2, arg_3) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use article <- decode.field(1, decode.string)
    use singular <- decode.field(2, decode.string)
    use plural <- decode.field(3, decode.string)
    decode.success(CreateNounRow(id:, article:, singular:, plural:))
  }

  "with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('noun')
    returning
      id
  )
insert into
  nouns (id, article, singular, plural)
select
  id,
  $1,
  $2,
  $3
from
  lexicon_insert
returning
  id,
  article,
  singular,
  plural
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_nouns` query
/// defined in `./src/app/noun/sql/find_nouns.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindNounsRow {
  FindNounsRow(
    id: Uuid,
    article: String,
    singular: String,
    plural: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
  )
}

/// Runs the `find_nouns` query
/// defined in `./src/app/noun/sql/find_nouns.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_nouns(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use article <- decode.field(1, decode.string)
    use singular <- decode.field(2, decode.string)
    use plural <- decode.field(3, decode.string)
    use created_at <- decode.field(4, pog.timestamp_decoder())
    use updated_at <- decode.field(5, pog.timestamp_decoder())
    decode.success(
      FindNounsRow(id:, article:, singular:, plural:, created_at:, updated_at:),
    )
  }

  "select
	*
from
	nouns
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_nouns_by_lang` query
/// defined in `./src/app/noun/sql/find_nouns_by_lang.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindNounsByLangRow {
  FindNounsByLangRow(
    id: Uuid,
    article: String,
    singular: String,
    plural: String,
    created_at: pog.Timestamp,
    updated_at: pog.Timestamp,
    translation: String,
  )
}

/// Runs the `find_nouns_by_lang` query
/// defined in `./src/app/noun/sql/find_nouns_by_lang.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_nouns_by_lang(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use article <- decode.field(1, decode.string)
    use singular <- decode.field(2, decode.string)
    use plural <- decode.field(3, decode.string)
    use created_at <- decode.field(4, pog.timestamp_decoder())
    use updated_at <- decode.field(5, pog.timestamp_decoder())
    use translation <- decode.field(6, decode.string)
    decode.success(
      FindNounsByLangRow(
        id:,
        article:,
        singular:,
        plural:,
        created_at:,
        updated_at:,
        translation:,
      ),
    )
  }

  "select
  n.*,
  t.translation as translation
from nouns as n
inner join translations as t on t.lexicon_id = n.id
where t.lang = $1
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
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
