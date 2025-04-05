with
  lexicon_insert as (
    insert into
      lexicon (category, concept)
    values
      ('verb', $1)
    returning
      id
  )
insert into
  verbs (id, infinitive, present, simple_past, present_perfect, translations)
select
  id,
  $1,
  $2,
  $3,
  $4,
  $5
from
  lexicon_insert
returning
  id;
