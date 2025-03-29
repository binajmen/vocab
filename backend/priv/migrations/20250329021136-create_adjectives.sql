--- migration:up
create table adjectives (
	id uuid primary key default gen_random_uuid (),
	positive text not null,
	comparative text not null,
	superlative text not null,
	created_at timestamp not null default now (),
	updated_at timestamp not null default now (),
	foreign key (id) references lexicons (id) on delete cascade on update cascade
);

create unique index adjectives_positive_idx on adjectives (positive);

--- migration:down
drop table adjectives;

--- migration:end
