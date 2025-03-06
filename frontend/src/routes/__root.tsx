import type { QueryClient } from "@tanstack/solid-query";
import {
  Link,
  Outlet,
  createRootRouteWithContext,
} from "@tanstack/solid-router";
import type { Api } from "~/api";

export const Route = createRootRouteWithContext<{
  api: Api;
  query: QueryClient;
}>()({
  component: () => {
    const Navigation = () => {
      return (
        <div class="p-2 flex gap-2">
          <Link to="/hello" class="[&.active]:font-bold">
            Home
          </Link>{" "}
          <Link to="/" class="[&.active]:font-bold">
            Home
          </Link>{" "}
          <Link to="/about" class="[&.active]:font-bold">
            About
          </Link>
          <Link to="/console/users">Users</Link>
        </div>
      );
    };
    return (
      <>
        <Navigation />
        <hr />
        <Outlet />
      </>
    );
  },
  notFoundComponent: () => <div>404 Not Found</div>,
});
