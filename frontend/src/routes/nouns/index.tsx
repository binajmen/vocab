import { createFileRoute } from "@tanstack/solid-router";
import { For } from "solid-js";
import { Link } from "@tanstack/solid-router";

export const Route = createFileRoute("/nouns/")({
  component: RouteComponent,
  loader: ({ context: { api, query } }) =>
    query.ensureQueryData(api.nouns.list),
});

function RouteComponent() {
  const nouns = Route.useLoaderData();

  return (
    <div class="p-8">
      <div class="flex justify-between items-start">
        <h1>Noun List</h1>
        <Link to="/nouns/create">Create New Noun</Link>
      </div>
      <ul>
        <For each={nouns()}>
          {(noun) => (
            <li>
              <Link to="/nouns/$id" params={{ id: noun.id }}>
                {noun.singular}
              </Link>
            </li>
          )}
        </For>
      </ul>
    </div>
  );
}
