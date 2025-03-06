import { createFileRoute } from "@tanstack/solid-router";

export const Route = createFileRoute("/console/users/$user_id")({
  component: RouteComponent,
  loader: ({ context: { api, query }, params }) =>
    query.ensureQueryData(api.users.find(params.user_id)),
});

function RouteComponent() {
  const user = Route.useLoaderData();

  return (
    <div>
      Hello "/console/users/$user_id"!
      <pre>{JSON.stringify(user(), null, 2)}</pre>
    </div>
  );
}
