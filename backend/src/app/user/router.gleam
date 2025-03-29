import app/context.{type Context}
import app/user/sql
import gleam/dynamic/decode
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub fn list_users(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_users(ctx.db))

    Ok(
      json.array(rows, fn(user) {
        json.object([
          #("id", json.string(uuid.to_string(user.id))),
          #("email", json.string(user.email)),
        ])
      }),
    )
  }

  case result {
    Ok(json) -> json.to_string_tree(json) |> wisp.json_response(200)
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn find_user(_req: Request, ctx: Context, user_id: String) -> Response {
  let assert Ok(user_id) = uuid.from_string(user_id)

  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_user(ctx.db, user_id))
    Ok(rows)
  }

  let user = case result {
    Ok([row]) ->
      Ok(
        json.object([
          #("id", json.string(uuid.to_string(row.id))),
          #("email", json.string(row.email)),
        ]),
      )
    Ok(_) -> Error("unique user not found")
    Error(_) -> Error("query error")
  }

  case user {
    Ok(user) -> json.to_string_tree(user) |> wisp.json_response(200)
    Error(_) -> wisp.internal_server_error()
  }
}

pub fn create_user(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  let decode_payload = {
    use email <- decode.field("email", decode.string)
    decode.success(email)
  }

  case decode.run(json, decode_payload) {
    Ok(email) -> {
      case sql.create_user(ctx.db, email) {
        Ok(pog.Returned(_, [row])) ->
          json.object([
            #("id", json.string(uuid.to_string(row.id))),
            #("email", json.string(row.email)),
          ])
          |> json.to_string_tree()
          |> wisp.json_response(200)
        Ok(pog.Returned(_, [])) -> wisp.unprocessable_entity()
        Ok(pog.Returned(_, [_, _, ..])) -> wisp.unprocessable_entity()
        Error(_) -> wisp.unprocessable_entity()
      }
    }
    Error(_) -> wisp.unprocessable_entity()
  }
}
