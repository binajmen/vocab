import type { QueryClient } from "@tanstack/solid-query";
import { Outlet, createRootRouteWithContext } from "@tanstack/solid-router";
import type { Api } from "~/api";

export const Route = createRootRouteWithContext<{
  api: Api;
  query: QueryClient;
}>()({
  component: () => {
    return <Outlet />;
  },
  notFoundComponent: () => <div>404 Not Found</div>,
});
