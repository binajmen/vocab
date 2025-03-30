select
  v.*,
  t.translation as translation
from verbs as v
inner join translations as t on t.lexicon_id = v.id
where t.lang = $1
