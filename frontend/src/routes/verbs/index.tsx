import { createFileRoute } from "@tanstack/solid-router";
import { For } from "solid-js";
import { Link } from "@tanstack/solid-router";

export const Route = createFileRoute("/verbs/")({
  component: RouteComponent,
  loader: ({ context: { api, query } }) =>
    query.ensureQueryData(api.verbs.list),
});

function RouteComponent() {
  const verbs = Route.useLoaderData();

  return (
    <div class="p-8">
      <div class="flex justify-between items-start">
        <h1>Verb List</h1>
        <Link to="/verbs/create">Create New Verb</Link>
      </div>
      <ul>
        <For each={verbs()}>
          {(verb) => (
            <li>
              <Link to="/verbs/$id" params={{ id: verb.id }}>
                {verb.infinitive}
              </Link>
            </li>
          )}
        </For>
      </ul>
    </div>
  );
}
