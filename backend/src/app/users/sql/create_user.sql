insert into
  users (id, email)
values
  ($1, $2)
returning
  id,
  email
