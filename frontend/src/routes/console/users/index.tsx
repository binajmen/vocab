import { createFileRoute, Link } from "@tanstack/solid-router";
import { For } from "solid-js";

export const Route = createFileRoute("/console/users/")({
  component: ConsoleUsersList,
  loader: ({ context: { api, query } }) =>
    query.ensureQueryData(api.users.list),
});

function ConsoleUsersList() {
  const users = Route.useLoaderData();

  return (
    <div class="p-2">
      Hello from /console/users/index!
      <For each={users()}>
        {(user) => (
          <div>
            {user.id} {user.email}{" "}
            <Link
              to="/console/users/$user_id"
              params={{ user_id: user.id }}
              preload="intent"
            >
              View
            </Link>
          </div>
        )}
      </For>
    </div>
  );
}
