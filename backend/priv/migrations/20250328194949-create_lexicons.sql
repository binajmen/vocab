--- migration:up
create table lexicons (
	id uuid primary key default gen_random_uuid (),
	class varchar(20) not null,
	created_at timestamp not null default now (),
	updated_at timestamp not null default now ()
);

create index lexicons_class_idx on lexicons (class);

--- migration:down
drop table lexicons;

--- migration:end
