--- migration:up
create table verbs (
	id uuid default gen_random_uuid (),
	lexicon_id uuid not null,
	infinitive text not null,
	present jsonb not null,
	simple_past jsonb not null,
	present_perfect jsonb not null,
	translations jsonb not null,
	-- constraints
	primary key (id),
	foreign key (lexicon_id) references lexicon (id),
	unique (infinitive)
);

--- migration:down
drop table verbs;

--- migration:end
