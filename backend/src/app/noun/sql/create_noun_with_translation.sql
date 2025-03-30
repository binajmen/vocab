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
