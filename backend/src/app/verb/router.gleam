import app/context.{type Context}
import app/translations
import app/utils
import app/verb/conjugation
import app/verb/sql
import app/verb/verb
import gleam/dynamic/decode
import gleam/function
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub fn list_verbs(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_verbs(ctx.db))
    Ok(
      json.array(rows, fn(verb) {
        let present = conjugation.to_dict(verb.present)
        let simple_past = conjugation.to_dict(verb.simple_past)
        let present_perfect = conjugation.to_dict(verb.present_perfect)

        json.object([
          #("id", json.string(uuid.to_string(verb.id))),
          #("infinitive", json.string(verb.infinitive)),
          #("present", json.dict(present, function.identity, json.string)),
          #(
            "simple_past",
            json.dict(simple_past, function.identity, json.string),
          ),
          #(
            "present_perfect",
            json.dict(present_perfect, function.identity, json.string),
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

pub fn find_verb(_req: Request, ctx: Context, verb_id: String) -> Response {
  let assert Ok(verb_id) = uuid.from_string(verb_id)

  case sql.find_verb(ctx.db, verb_id) {
    Ok(pog.Returned(_, [verb])) -> {
      let present = conjugation.to_dict(verb.present)
      let simple_past = conjugation.to_dict(verb.simple_past)
      let present_perfect = conjugation.to_dict(verb.present_perfect)
      let translations = translations.to_dict(verb.translations)

      json.object([
        #("id", json.string(uuid.to_string(verb.id))),
        #("infinitive", json.string(verb.infinitive)),
        #("present", json.dict(present, function.identity, json.string)),
        #("simple_past", json.dict(simple_past, function.identity, json.string)),
        #(
          "present_perfect",
          json.dict(present_perfect, function.identity, json.string),
        ),
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

pub fn create_verb(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode.run(json, verb.decoder()) {
    Ok(verb) -> {
      let present = conjugation.to_json(verb.present)
      let simple_past = conjugation.to_json(verb.simple_past)
      let present_perfect = conjugation.to_json(verb.present_perfect)
      let translations = translations.to_json(verb.translations)

      case
        sql.create_verb(
          ctx.db,
          verb.infinitive,
          present,
          simple_past,
          present_perfect,
          translations,
        )
      {
        Ok(pog.Returned(_, [verb])) ->
          json.object([#("id", json.string(uuid.to_string(verb.id)))])
          |> json.to_string_tree()
          |> wisp.json_response(200)
        Ok(pog.Returned(_, _)) -> wisp.unprocessable_entity()
        Error(error) -> {
          utils.json_pog_error(error)
          |> wisp.json_response(404)
        }
      }
    }
    Error(errors) -> {
      utils.json_decode_errors(errors)
      |> wisp.json_response(404)
    }
  }
}

pub fn update_verb(req: Request, ctx: Context, verb_id: String) {
  use json <- wisp.require_json(req)
  let assert Ok(verb_id) = uuid.from_string(verb_id)

  case decode.run(json, verb.decoder()) {
    Ok(verb) -> {
      let present = conjugation.to_json(verb.present)
      let simple_past = conjugation.to_json(verb.simple_past)
      let present_perfect = conjugation.to_json(verb.present_perfect)
      let translations = translations.to_json(verb.translations)

      case
        sql.update_verb(
          ctx.db,
          verb_id,
          verb.infinitive,
          present,
          simple_past,
          present_perfect,
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
    Error(errors) -> {
      utils.json_decode_errors(errors)
      |> wisp.json_response(404)
    }
  }
}
