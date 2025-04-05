--- migration:up
create table nouns (
	id uuid default gen_random_uuid (),
	lexicon_id uuid not null,
	article text not null,
	singular text not null,
	plural text not null,
	translations jsonb not null,
	-- constraints
	primary key (id),
	foreign key (lexicon_id) references lexicon (id),
	unique (singular)
);

--- migration:down
drop table nouns;

--- migration:end
