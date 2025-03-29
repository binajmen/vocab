--- migration:up
create table verbs (
  id uuid primary key default gen_random_uuid (),
  infinitive text not null,
  present jsonb not null default '{}'::jsonb,
  present_perfect jsonb not null default '{}'::jsonb,
  past jsonb not null default '{}'::jsonb,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now()
);

create unique index verbs_infinitive_idx on verbs (infinitive);

--- migration:down
drop table verbs;

--- migration:end

