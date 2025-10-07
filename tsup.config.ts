import { defineConfig } from "tsup"

export default defineConfig([
  {
    entry: ["src/server.ts"],
    outDir: "dist",
    format: ["esm"],
    minify: true,
    sourcemap: true,
    clean: true,
  },
  {
    entry: ["prisma/seed.ts"],
    outDir: "dist",
    format: ["esm"],
    sourcemap: false,
    clean: false,
  }
])
