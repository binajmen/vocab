import app/context.{type Context}
import app/utils
import app/verb/sql
import gleam/dict
import gleam/dynamic/decode
import gleam/function
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

pub type Conjugation {
  Conjugation(
    ich: String,
    du: String,
    er_sie_es: String,
    wir: String,
    ihr: String,
    sie: String,
  )
}

pub type Verb {
  Verb(
    infinitive: String,
    present: Conjugation,
    present_perfect: Conjugation,
    past: Conjugation,
  )
}

fn parse_conjugation(conjugation: String) {
  conjugation
  |> json.parse(decode.dict(decode.string, decode.string))
  |> result.unwrap(dict.new())
}

pub fn list_verbs(_req: Request, ctx: Context) -> Response {
  let result = {
    use pog.Returned(_, rows) <- result.try(sql.find_verbs(ctx.db))
    Ok(
      json.array(rows, fn(verb) {
        let present = parse_conjugation(verb.present)
        let present_perfect = parse_conjugation(verb.present_perfect)
        let past = parse_conjugation(verb.past)

        json.object([
          #("id", json.string(uuid.to_string(verb.id))),
          #("infinitive", json.string(verb.infinitive)),
          #("present", json.dict(present, function.identity, json.string)),
          #(
            "present_perfect",
            json.dict(present_perfect, function.identity, json.string),
          ),
          #("past", json.dict(past, function.identity, json.string)),
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

fn decode_conjugation() {
  use ich <- decode.field("ich", decode.string)
  use du <- decode.field("du", decode.string)
  use er_sie_es <- decode.field("er_sie_es", decode.string)
  use wir <- decode.field("wir", decode.string)
  use ihr <- decode.field("ihr", decode.string)
  use sie <- decode.field("sie", decode.string)
  decode.success(Conjugation(ich, du, er_sie_es, wir, ihr, sie))
}

fn decode_verb() {
  use infinitive <- decode.field("infinitive", decode.string)
  use present <- decode.field("present", decode_conjugation())
  use present_perfect <- decode.field("present_perfect", decode_conjugation())
  use past <- decode.field("past", decode_conjugation())
  decode.success(Verb(infinitive, present, present_perfect, past))
}

fn json_conjugation(conjugation: Conjugation) {
  json.object([
    #("ich", json.string(conjugation.ich)),
    #("du", json.string(conjugation.du)),
    #("er_sie_es", json.string(conjugation.er_sie_es)),
    #("wir", json.string(conjugation.wir)),
    #("ihr", json.string(conjugation.ihr)),
    #("sie", json.string(conjugation.sie)),
  ])
}

pub fn create_verb(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode.run(json, decode_verb()) {
    Ok(verb) -> {
      let present = json_conjugation(verb.present)
      let present_perfect = json_conjugation(verb.present_perfect)
      let past = json_conjugation(verb.past)

      case
        sql.create_verb(ctx.db, verb.infinitive, present, present_perfect, past)
      {
        Ok(pog.Returned(_, [verb])) ->
          json.object([
            #("id", json.string(uuid.to_string(verb.id))),
            #("infinitive", json.string(verb.infinitive)),
            #("present", present),
            #("present_perfect", present_perfect),
            #("past", past),
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
    Error(errors) -> {
      utils.json_decode_errors(errors)
      |> wisp.json_response(404)
    }
  }
}
