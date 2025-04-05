with
  lexicon_insert as (
    insert into
      lexicon(category, concept)
    values
      ('noun', $2)
    returning
      id
  )
insert into
  nouns (id, article, singular, plural, translations)
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
