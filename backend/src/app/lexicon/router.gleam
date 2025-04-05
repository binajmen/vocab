import app/context.{type Context}
import app/lexicon/sql
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub fn list_lexicon(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_lexicons(ctx.db))

    Ok(
      json.array(rows, fn(lexicon) {
        json.object([
          #("id", json.string(uuid.to_string(lexicon.id))),
          #("category", json.string(lexicon.category)),
          #("concept", json.string(lexicon.concept)),
        ])
      }),
    )
  }

  case result {
    Ok(json) -> json.to_string_tree(json) |> wisp.json_response(200)
    Error(_) -> wisp.internal_server_error()
  }
}
