import app/adjective/adjective
import app/adjective/sql
import app/context.{type Context}
import app/translations
import app/utils
import gleam/dynamic/decode
import gleam/function
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub fn list_adjectives(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_adjectives(ctx.db))
    Ok(
      json.array(rows, fn(adjective) {
        let translations = translations.to_dict(adjective.translations)

        json.object([
          #("id", json.string(uuid.to_string(adjective.id))),
          #("positive", json.string(adjective.positive)),
          #("comparative", json.string(adjective.comparative)),
          #("superlative", json.string(adjective.superlative)),
          #(
            "translations",
            json.dict(translations, function.identity, json.string),
          ),
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

pub fn create_adjective(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode.run(json, adjective.decoder()) {
    Ok(adjective) -> {
      let translations = translations.to_json(adjective.translations)

      case
        sql.create_adjective(
          ctx.db,
          adjective.positive,
          adjective.comparative,
          adjective.superlative,
          translations,
        )
      {
        Ok(pog.Returned(_, [adjective])) ->
          json.object([#("id", json.string(uuid.to_string(adjective.id)))])
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
