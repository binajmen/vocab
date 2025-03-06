--- migration:up
create extension if not exists "uuid-ossp";

--- migration:down
drop extension if exists "uuid-ossp";

--- migration:end
