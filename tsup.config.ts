import { cpSync } from "node:fs";
import { resolve } from "node:path";
import { defineConfig } from "tsup";

export default defineConfig({
  clean: true,
  entry: {
    index: "src/action.js", // Bundle src/action.js → dist/index.js
  },
  format: ["cjs"],
  minify: true,
  noExternal: [/(.*)/],
  onSuccess: async () => {
    // Copy all helper scripts to dist/scripts/
    const src = resolve("src/scripts/");
    const dest = resolve("dist/scripts/");
    cpSync(src, dest, { recursive: true });

    console.log(
      "✅ Action bundle completed: dist/ now contains compiled JS and scripts",
    );
  },
  outDir: "dist",
  shims: false,
  target: "node20",
});
