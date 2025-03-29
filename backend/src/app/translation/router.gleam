import app/context.{type Context}
import app/translation/sql
import app/utils
import gleam/dynamic
import gleam/dynamic/decode
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub type Translation {
  Translation(lexicon_id: uuid.Uuid, translation: String, lang: String)
}

pub fn list_translations(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_translations(ctx.db))
    Ok(
      json.array(rows, fn(translation) {
        json.object([
          #("id", json.string(uuid.to_string(translation.id))),
          #("lexicon_id", json.string(uuid.to_string(translation.lexicon_id))),
          #("translation", json.string(translation.translation)),
          #("lang", json.string(translation.lang)),
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

fn decode_translation() {
  use lexicon_id <- decode.field("lexicon_id", utils.decode_uuid())
  use translation <- decode.field("translation", decode.string)
  use lang <- decode.field("lang", decode.string)
  decode.success(Translation(lexicon_id, translation, lang))
}

pub fn create_translation(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode.run(json, decode_translation()) {
    Ok(translation) -> {
      case
        sql.create_translation(
          ctx.db,
          translation.lexicon_id,
          translation.translation,
          translation.lang,
        )
      {
        Ok(pog.Returned(_, [created])) ->
          json.object([
            #("id", json.string(uuid.to_string(created.id))),
            #("translation", json.string(created.translation)),
            #("lang", json.string(created.lang)),
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
