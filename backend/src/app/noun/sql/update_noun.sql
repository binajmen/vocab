update
  nouns
set
  article = $2,
  singular = $3,
  plural = $4
where
  id = $1
returning
  id,
  article,
  singular,
  plural
