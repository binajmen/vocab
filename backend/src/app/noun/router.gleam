import app/context.{type Context}
import app/noun/sql
import app/utils
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub type Noun {
  Noun(article: String, singular: String, plural: String)
}

pub fn list_nouns(req: Request, ctx: Context) -> Response {
  let lang = wisp.get_query(req) |> list.key_find("lang")
  case lang {
    Ok(lang) -> list_nouns_by_lang(ctx, lang)
    Error(_) -> list_all_nouns(ctx)
  }
}

fn list_all_nouns(ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_nouns(ctx.db))
    Ok(
      json.array(rows, fn(noun) {
        json.object([
          #("id", json.string(uuid.to_string(noun.id))),
          #("article", json.string(noun.article)),
          #("singular", json.string(noun.singular)),
          #("plural", json.string(noun.plural)),
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

fn list_nouns_by_lang(ctx: Context, lang: String) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_nouns_by_lang(ctx.db, lang))
    Ok(
      json.array(rows, fn(noun) {
        json.object([
          #("id", json.string(uuid.to_string(noun.id))),
          #("article", json.string(noun.article)),
          #("singular", json.string(noun.singular)),
          #("plural", json.string(noun.plural)),
          #("translation", json.string(noun.translation)),
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

fn decode_noun() {
  use article <- decode.field("article", decode.string)
  use singular <- decode.field("singular", decode.string)
  use plural <- decode.field("plural", decode.string)
  decode.success(Noun(article, singular, plural))
}

pub fn create_noun(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode.run(json, decode_noun()) {
    Ok(noun) -> {
      case sql.create_noun(ctx.db, noun.article, noun.singular, noun.plural) {
        Ok(pog.Returned(_, [noun])) ->
          json.object([
            #("id", json.string(uuid.to_string(noun.id))),
            #("article", json.string(noun.article)),
            #("singular", json.string(noun.singular)),
            #("plural", json.string(noun.plural)),
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
