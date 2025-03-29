--- migration:up
create table users (
  id uuid primary key default gen_random_uuid (),
  email varchar(255) not null
);

create unique index users_email_idx on users (email);

--- migration:down
drop table if exists users;

--- migration:end
