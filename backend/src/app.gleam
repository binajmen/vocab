import app/context
import app/router
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()
  let assert Ok(ctx) = context.init()
  let assert Ok(_) = start_http_server(ctx)
  process.sleep_forever()
}

fn start_http_server(ctx) {
  let secret_key_base = wisp.random_string(64)

  router.handle_request(_, ctx)
  |> wisp_mist.handler(secret_key_base)
  |> mist.new()
  |> mist.bind("0.0.0.0")
  |> mist.port(8010)
  |> mist.start_http
}
