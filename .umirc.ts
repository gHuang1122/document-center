import { defineConfig } from "umi";

export default defineConfig({
  mfsu: {},
  plugins: ["./plugins/routes.ts", "./plugins/compile.ts"],
});
