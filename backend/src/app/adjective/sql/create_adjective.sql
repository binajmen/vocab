with
  lexicon_insert as (
    insert into
      lexicons (class)
    values
      ('adjective')
    returning
      id
  )
insert into
  adjectives (id, positive, comparative, superlative)
select
  id,
  $1,
  $2,
  $3
from
  lexicon_insert
returning
  id,
  positive,
  comparative,
  superlative;
