--- migration:up
create table adjectives (
	id uuid default gen_random_uuid (),
	lexicon_id uuid not null,
	positive text not null,
	comparative text not null,
	superlative text not null,
	translations jsonb not null,
	-- constraints
	primary key (id),
	foreign key (lexicon_id) references lexicon (id),
	unique (positive)
);

--- migration:down
drop table adjectives;

--- migration:end
