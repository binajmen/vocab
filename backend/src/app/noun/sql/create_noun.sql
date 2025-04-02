with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('noun')
    returning
      id
  )
insert into
  nouns (id, article, singular, plural)
select
  id,
  $1,
  $2,
  $3
from
  lexicon_insert
returning
  *;
