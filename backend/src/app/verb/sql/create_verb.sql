with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('verb')
    returning
      id
  )
insert into
  verbs (id, infinitive, present, simple_past, present_perfect)
select
  id,
  $1,
  $2,
  $3,
  $4
from
  lexicon_insert
returning
  id,
  infinitive,
  present,
  simple_past,
  present_perfect
