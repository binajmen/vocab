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
  verbs (id, infinitive, present, present_perfect, past)
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
  present_perfect,
  past;
