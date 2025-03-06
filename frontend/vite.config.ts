import { TanStackRouterVite } from "@tanstack/router-plugin/vite";
import { defineConfig } from "vite";
import solidPlugin from "vite-plugin-solid";
import viteTsConfigPaths from "vite-tsconfig-paths";
import devtools from "solid-devtools/vite";

export default defineConfig({
  plugins: [
    devtools(),
    TanStackRouterVite({ target: "solid", autoCodeSplitting: true }),
    viteTsConfigPaths({
      projects: ["./tsconfig.json"],
    }),
    solidPlugin(),
  ],
  server: {
    port: 3010,
  },
  build: {
    target: "esnext",
  },
});
