import type { IApi } from "umi";
import MdLoader from "./loaders/markdown/index";

export default (api: IApi) => {
  api.describe({ key: "domi:compile" });

  api.chainWebpack(async (memo) => {
    const babelInUmi = memo.module.rule("src").use("babel-loader").entries();
    const loaderPath = require.resolve("./loaders/markdown/loader.js");
    memo.module
      // 通过链式处理，向`webpack`添加了一条名为`domi-md`的处理规则
      .rule("domi-md")
      // 该规则用于处理`.md`文件
      .test(/\.md$/)
      // 表示文件经过这个loader处理后转换为可导入的js模块
      .type("javascript/auto")
      // 用默认带的babel-loader来处理react组件
      .use("babel-loader")
      .loader(babelInUmi.loader)
      .options(babelInUmi.options)
      .end()
      // 给这个loader取个名字
      .use("md-loader")
      // loader的路径
      .loader(loaderPath)
      .options({
        handler: MdLoader,
      });

    return memo;
  });
};
