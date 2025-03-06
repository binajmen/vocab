import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_users` query
/// defined in `./src/app/users/sql/find_users.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindUsersRow {
  FindUsersRow(id: Uuid, email: String)
}

/// Runs the `find_users` query
/// defined in `./src/app/users/sql/find_users.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_users(db) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use email <- decode.field(1, decode.string)
    decode.success(FindUsersRow(id:, email:))
  }

  "select
  *
from
  users;
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `create_user` query
/// defined in `./src/app/users/sql/create_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateUserRow {
  CreateUserRow(id: Uuid, email: String)
}

/// Runs the `create_user` query
/// defined in `./src/app/users/sql/create_user.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_user(db, arg_1, arg_2) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use email <- decode.field(1, decode.string)
    decode.success(CreateUserRow(id:, email:))
  }

  "insert into
  users (id, email)
values
  ($1, $2)
returning
  id,
  email
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_user` query
/// defined in `./src/app/users/sql/find_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindUserRow {
  FindUserRow(id: Uuid, email: String)
}

/// Runs the `find_user` query
/// defined in `./src/app/users/sql/find_user.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_user(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use email <- decode.field(1, decode.string)
    decode.success(FindUserRow(id:, email:))
  }

  "select
  *
from
  users
where
  users.id = $1
"
  |> pog.query
  |> pog.parameter(pog.text(uuid.to_string(arg_1)))
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
