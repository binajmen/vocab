import tailwindcss from "@tailwindcss/vite";
import { TanStackRouterVite } from "@tanstack/router-plugin/vite";
import devtools from "solid-devtools/vite";
import { defineConfig } from "vite";
import solidPlugin from "vite-plugin-solid";
import viteTsConfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  plugins: [
    devtools({ autoname: true }),
    TanStackRouterVite({ target: "solid", autoCodeSplitting: true }),
    viteTsConfigPaths({
      projects: ["./tsconfig.json"],
    }),
    solidPlugin(),
    {
      name: "sql-loader",
      transform(code, id) {
        if (id.endsWith(".sql")) {
          const content = JSON.stringify(code);
          return `export default ${content};`;
        }
      },
    },
    tailwindcss(),
  ],
  server: {
    port: 3010,
    headers: {
      "Cross-Origin-Embedder-Policy": "require-corp",
      "Cross-Origin-Opener-Policy": "same-origin",
    },
    allowedHosts: [
      "mbp.tail8eb228.ts.net",
      "6aad-2a02-a03f-6187-c200-8f2-abae-304c-8f7e.ngrok-free.app",
    ],
  },
  build: {
    target: "esnext",
  },
  optimizeDeps: {
    exclude: ["@sqlite.org/sqlite-wasm"],
  },
});
