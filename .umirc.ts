import { defineConfig } from 'umi';

export default defineConfig({
  nodeModulesTransform: {
    type: 'none',
  },
  // 此路由最少保证存在一条
  routes: [
    {
      path: '/',
      component: '@/layout/index',
      exact: false,
    },
  ],
  fastRefresh: {},
  // plugins: ['./src/features/routes.ts','./src/features/compile.ts'],
  plugins: ['./src/features/routes.ts'],
  chainWebpack(memo, { env, webpack, createCSSRule }) {

  },
});
