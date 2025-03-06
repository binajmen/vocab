import { createFileRoute, Outlet } from "@tanstack/solid-router";

export const Route = createFileRoute("/console/users")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <div>
      Hello "/console/users/layout"!
      <Outlet />
    </div>
  );
}
