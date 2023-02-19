import { IApi } from 'umi';

export default (api: IApi) => {
  api.describe({ key: 'domi:compile' });

  api.chainWebpack(async (memo) => {
    const loaderPath = require.resolve('../loaders/markdown/loader.js');
    memo.module
      // 通过链式处理，向`webpack`添加了一条名为`domi-md`的处理规则
      .rule('domi-md')
      // 该规则用于处理`.md`文件
      .test(/\.md$/)
      // 给这个loader取个名字
      .use('md-loader')
      // loader的路径
      .loader(loaderPath);
    return memo;
  });
};
