--- migration:up
create table nouns (
  id uuid primary key default gen_random_uuid (),
  article text not null,
  singular text not null,
  plural text not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now()
);

create unique index nouns_singular_idx on nouns (singular);

--- migration:down
drop table nouns;

--- migration:end
