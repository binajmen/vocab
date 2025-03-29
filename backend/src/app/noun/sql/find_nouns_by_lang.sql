select
  n.*,
  t.translation as translation
from nouns as n
inner join translations as t on t.lexicon_id = n.id
where t.lang = $1
