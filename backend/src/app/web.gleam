import cors_builder
import gleam/http
import wisp

pub fn cors() {
  cors_builder.new()
  |> cors_builder.allow_origin("*")
  |> cors_builder.allow_method(http.Get)
  |> cors_builder.allow_method(http.Post)
  |> cors_builder.allow_method(http.Put)
  |> cors_builder.allow_method(http.Patch)
  |> cors_builder.allow_header("content-type")
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(req)
}
