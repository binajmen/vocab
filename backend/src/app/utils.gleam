import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/string
import pog

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
