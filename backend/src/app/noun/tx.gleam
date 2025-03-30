import gleam/dynamic/decode
import pog

pub fn create_noun_with_translation(db, arg_1, arg_2, arg_3, arg_4, arg_5) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "
begin;
with
  lexicon_insert as (
    insert into lexicons (class)
    values ('noun')
    returning id
  ),
  noun_insert as (
    insert into nouns (id, article, singular, plural)
    select id, $1, $2, $3
    from lexicon_insert
    returning id
  )
insert into translations (lexicon_id, translation, lang)
select id, $4, $5
from noun_insert;
commit;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.parameter(pog.text(arg_5))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
