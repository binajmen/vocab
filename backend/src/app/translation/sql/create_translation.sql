insert into
  translations (lexicon_id, translation, lang)
values
  ($1, $2, $3)
returning
  id,
  lexicon_id,
  translation,
  lang
