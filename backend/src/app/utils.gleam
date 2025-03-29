import gleam/dynamic
import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/string
import pog
import youid/uuid

pub fn decode_uuid() -> decode.Decoder(uuid.Uuid) {
  decode.new_primitive_decoder("Uuid", fn(data) {
    case decode.run(dynamic.from(data), decode.string) {
      Ok(string) ->
        case uuid.from_string(string) {
          Ok(uuid) -> Ok(uuid)
          Error(_) -> Error(uuid.v4())
        }
      Error(_) -> Error(uuid.v4())
    }
  })
}

pub fn json_decode_errors(errors: List(decode.DecodeError)) {
  let errors =
    list.map(errors, fn(error) {
      case error {
        decode.DecodeError(expected, found, path) -> #(
          string.join(path, "."),
          json.object([
            #("expected", json.string(expected)),
            #("found", json.string(found)),
          ]),
        )
      }
    })

  json.object([
    #("error", json.string("wrong_format")),
    #("details", json.object(errors)),
  ])
  |> json.to_string_tree()
}

pub fn json_pog_error(error: pog.QueryError) {
  case error {
    pog.ConstraintViolated(message, constraint, detail) ->
      json.object([
        #("error", json.string("constraint_violated")),
        #(
          "detail",
          json.object([
            #("message", json.string(message)),
            #("constraint", json.string(constraint)),
            #("detail", json.string(detail)),
          ]),
        ),
      ])
    _ -> json.string("Undocumented error")
    // pog.ConnectionUnavailable -> todo
    // pog.PostgresqlError(_, _, _) -> todo
    // pog.QueryTimeout -> todo
    // pog.UnexpectedArgumentCount(_, _) -> todo
    // pog.UnexpectedArgumentType(_, _) -> todo
    // pog.UnexpectedResultType(_) -> todo
  }
  |> json.to_string_tree()
}
