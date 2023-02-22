import { defineConfig } from "umi";

export default defineConfig({
  // routes: [
  //   { path: "/", component: "index" },
  //   { path: "/docs", component: "docs" },
  // ],
  mfsu: {},
  plugins: ["./plugins/routes.ts", "./plugins/compile.ts"],
});
