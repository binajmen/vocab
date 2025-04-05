--- migration:up
create table users (
	id uuid default gen_random_uuid (),
	email varchar(255) not null,
	-- constraints
	primary key (id),
	unique (email)
);

--- migration:down
drop table users;

--- migration:end
