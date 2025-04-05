with
  lexicon_insert as (
    insert into
      lexicon (category, concept)
    values
      ('adjective', $1)
    returning
      id
  )
insert into
  adjectives (id, positive, comparative, superlative, translations)
select
  id,
  $1,
  $2,
  $3,
  $4
from
  lexicon_insert
returning
  id;
