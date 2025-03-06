--- migration:up
create table users (
  id uuid primary key default gen_random_uuid (),
  email varchar(255) not null unique
);

--- migration:down
drop table if exists users;

--- migration:end
