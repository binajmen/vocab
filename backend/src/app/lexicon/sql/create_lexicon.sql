insert into
  lexicons (class)
values
  ($1)
returning
  id,
  class
