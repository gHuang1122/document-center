import { defineConfig } from 'umi'
import path from 'path'
export default defineConfig({
  mfsu: {},
  plugins: ['./plugins/routes.ts', './plugins/compile.ts'],
  routes: [
    {
      path: '/',
      file: path.resolve(__dirname, './src/pages/Home/index.tsx'),
    },
  ],
})
