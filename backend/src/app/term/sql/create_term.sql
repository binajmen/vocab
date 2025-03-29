with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('term')
    returning
      id
  )
insert into
  terms (id, term)
select
  id,
  $1
from
  lexicon_insert
returning
  id,
  term
