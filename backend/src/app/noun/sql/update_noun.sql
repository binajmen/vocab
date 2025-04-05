update
  nouns
set
  article = $2,
  singular = $3,
  plural = $4,
  translations = $5
where
  id = $1
