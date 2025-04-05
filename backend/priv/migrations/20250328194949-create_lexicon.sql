--- migration:up
create table categories (name text primary key);

insert into
	categories (name)
values
	('noun'),
	('verb'),
	('adjective'),
	('adverb'),
	('preposition');

create table lexicon (
	id uuid default gen_random_uuid (),
	category text not null,
	concept text not null,
	-- constraints
	primary key (id),
	foreign key (category) references categories (name),
	unique (category, concept)
);

--- migration:down
drop table lexicon;

drop table categories;

--- migration:end
