--- migration:up
create table terms (
	id uuid primary key default uuid_generate_v4 (),
	term text not null,
	created_at timestamp not null default now (),
	updated_at timestamp not null default now (),
	foreign key (id) references lexicons (id) on delete cascade on update cascade
);

create unique index terms_term_idx on terms (term);

--- migration:down
drop table terms;

--- migration:end
