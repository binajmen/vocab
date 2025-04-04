import app/context.{type Context}
import app/noun/sql
import app/utils
import gleam/dict
import gleam/dynamic/decode
import gleam/function
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
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
        let translations =
          noun.translations
          |> json.parse(decode.dict(decode.string, decode.string))
          |> result.unwrap(dict.new())

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

fn list_nouns_by_lang(ctx: Context, lang: String) -> Response {
  todo
}

pub fn find_noun(_req: Request, ctx: Context, noun_id: String) {
  case uuid.from_string(noun_id) {
    Ok(noun_id) -> {
      case sql.find_noun(ctx.db, noun_id) {
        Ok(pog.Returned(_, [noun])) ->
          json.object([
            #("id", json.string(uuid.to_string(noun.id))),
            #("article", json.string(noun.article)),
            #("singular", json.string(noun.singular)),
            #("plural", json.string(noun.plural)),
          ])
          |> json.to_string_tree()
          |> wisp.json_response(200)
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

pub fn update_noun(req: Request, ctx: Context, noun_id: String) {
  use json <- wisp.require_json(req)
  let assert Ok(noun_id) = uuid.from_string(noun_id)

  case decode.run(json, decode_noun()) {
    Ok(noun) -> {
      case
        sql.update_noun(
          ctx.db,
          noun_id,
          noun.article,
          noun.singular,
          noun.plural,
        )
      {
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
