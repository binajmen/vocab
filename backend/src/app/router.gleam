import app/context.{type Context}
import app/noun/router as noun
import app/user/router as user
import app/verb/router as verb
import app/web
import cors_builder
import gleam/http.{Get, Post}
import wisp.{type Request, type Response}

pub fn handle_get(req: Request, ctx: Context) {
  case wisp.path_segments(req) {
    ["healthcheck"] -> wisp.ok()
    ["users"] -> user.list_users(req, ctx)
    ["users", user_id] -> user.find_user(req, ctx, user_id)
    ["nouns"] -> noun.list_nouns(req, ctx)
    ["nouns", noun_id] -> noun.find_noun(req, ctx, noun_id)
    ["verbs"] -> verb.list_verbs(req, ctx)
    ["verbs", verb_id] -> verb.find_verb(req, ctx, verb_id)
    _ -> wisp.not_found()
  }
}

pub fn handle_post(req: Request, ctx: Context) {
  case wisp.path_segments(req) {
    ["users"] -> user.create_user(req, ctx)
    ["nouns"] -> noun.create_noun(req, ctx)
    ["nouns", noun_id] -> noun.update_noun(req, ctx, noun_id)
    ["verbs"] -> verb.create_verb(req, ctx)
    ["verbs", verb_id] -> verb.update_verb(req, ctx, verb_id)
    _ -> wisp.not_found()
  }
}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- cors_builder.wisp_middleware(req, web.cors())
  use req <- web.middleware(req)

  case req.method {
    http.Get -> handle_get(req, ctx)
    http.Post -> handle_post(req, ctx)
    _ -> wisp.not_found()
  }
}
