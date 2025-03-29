import app/context.{type Context}
import app/term/sql
import app/utils
import gleam/dynamic/decode
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub type Misc {
  Misc(term: String)
}

pub fn list_terms(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_terms(ctx.db))
    Ok(
      json.array(rows, fn(misc) {
        json.object([
          #("id", json.string(uuid.to_string(misc.id))),
          #("term", json.string(misc.term)),
        ])
      }),
    )
  }

  case result {
    Ok(json) -> json.to_string_tree(json) |> wisp.json_response(200)
    Error(error) -> {
      utils.json_pog_error(error)
      |> wisp.json_response(404)
    }
  }
}

fn decode_misc() {
  use term <- decode.field("term", decode.string)
  decode.success(Misc(term))
}

pub fn create_term(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode.run(json, decode_misc()) {
    Ok(misc) -> {
      case sql.create_term(ctx.db, misc.term) {
        Ok(pog.Returned(_, [misc])) ->
          json.object([
            #("id", json.string(uuid.to_string(misc.id))),
            #("term", json.string(misc.term)),
          ])
          |> json.to_string_tree()
          |> wisp.json_response(200)
        Ok(pog.Returned(_, _)) -> wisp.unprocessable_entity()
        Error(error) -> {
          utils.json_pog_error(error)
          |> wisp.json_response(404)
        }
      }
    }
    Error(errors) ->
      utils.json_decode_errors(errors)
      |> wisp.json_response(404)
  }
}
