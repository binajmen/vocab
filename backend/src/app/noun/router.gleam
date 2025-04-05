import app/context.{type Context}
import app/noun/noun
import app/noun/sql
import app/translations
import app/utils
import gleam/dynamic/decode
import gleam/function
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub fn list_nouns(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_nouns(ctx.db))
    Ok(
      json.array(rows, fn(noun) {
        let translations = translations.to_dict(noun.translations)

        json.object([
          #("id", json.string(uuid.to_string(noun.id))),
          #("article", json.string(noun.article)),
          #("singular", json.string(noun.singular)),
          #("plural", json.string(noun.plural)),
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

pub fn find_noun(_req: Request, ctx: Context, noun_id: String) {
  case uuid.from_string(noun_id) {
    Ok(noun_id) -> {
      case sql.find_noun(ctx.db, noun_id) {
        Ok(pog.Returned(_, [noun])) -> {
          let translations = translations.to_dict(noun.translations)

          json.object([
            #("id", json.string(uuid.to_string(noun.id))),
            #("article", json.string(noun.article)),
            #("singular", json.string(noun.singular)),
            #("plural", json.string(noun.plural)),
            #(
              "translations",
              json.dict(translations, function.identity, json.string),
            ),
          ])
          |> json.to_string_tree()
          |> wisp.json_response(200)
        }
        Ok(pog.Returned(_, _)) -> wisp.not_found()
        Error(error) -> {
          utils.json_pog_error(error)
          |> wisp.json_response(404)
        }
      }
    }
    Error(_) -> wisp.not_found()
  }
}

pub fn create_noun(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode.run(json, noun.decoder()) {
    Ok(noun) -> {
      let translations =
        json.dict(noun.translations, function.identity, json.string)

      case
        sql.create_noun(
          ctx.db,
          noun.article,
          noun.singular,
          noun.plural,
          translations,
        )
      {
        Ok(pog.Returned(_, [noun])) ->
          json.object([#("id", json.string(uuid.to_string(noun.id)))])
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

pub fn update_noun(req: Request, ctx: Context, noun_id: String) {
  use json <- wisp.require_json(req)
  let assert Ok(noun_id) = uuid.from_string(noun_id)

  case decode.run(json, noun.decoder()) {
    Ok(noun) -> {
      let translations =
        json.dict(noun.translations, function.identity, json.string)

      case
        sql.update_noun(
          ctx.db,
          noun_id,
          noun.article,
          noun.singular,
          noun.plural,
          translations,
        )
      {
        Ok(pog.Returned(_, _)) -> wisp.ok()
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
