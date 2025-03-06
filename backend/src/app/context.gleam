import envoy
import gleam/result
import pog

pub type Context {
  Context(db: pog.Connection)
}

pub fn init() -> Result(Context, String) {
  let assert Ok(db) = init_database()
  Ok(Context(db))
}

fn init_database() {
  use database_url <- result.try(envoy.get("DATABASE_URL"))
  use config <- result.try(pog.url_config(database_url))
  Ok(pog.connect(config))
}
