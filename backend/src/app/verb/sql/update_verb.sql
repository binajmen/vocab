update
  verbs
set
  infinitive = $2,
  present = $3,
  simple_past = $4,
  present_perfect = $5
where
  id = $1
returning
  id,
  infinitive,
  present,
  simple_past,
  present_perfect
