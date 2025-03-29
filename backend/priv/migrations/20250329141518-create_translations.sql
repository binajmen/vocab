--- migration:up
create table translations (
	id uuid primary key default uuid_generate_v4 (),
	lexicon_id uuid not null,
	translation text not null,
	lang char(2) not null,
	foreign key (lexicon_id) references lexicons (id) on delete cascade on update cascade
);

create unique index translations_lexicon_id_lang_idx on translations (lexicon_id, lang);

create index translations_lang_idx on translations (lang);

--- migration:down
drop table translations;

--- migration:end
