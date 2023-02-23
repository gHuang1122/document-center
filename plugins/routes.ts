import path from "path";
import type { IApi } from "umi";
import type { IRoute } from "@umijs/core/dist/types";
import { getConventionRoutes } from "@umijs/core";
import { winPath } from "umi/plugin-utils";
import { Md5 } from "ts-md5";

export default (api: IApi) => {
  api.describe({ key: "domi:routes" });

  api.modifyRoutes((oRoutes: Record<string, IRoute>) => {
    const routes: Record<string, IRoute> = {};

    const docDir = "docs";
    const dirRoutes: Record<string, IRoute> = getConventionRoutes({
      base: path.join(api.cwd, docDir),
    });

    // 默认提供的布局layout的Id
    let docLayoutId: undefined | string = "@@/global-layout";
    routes[docLayoutId] = oRoutes[docLayoutId];
    Object.entries(dirRoutes).forEach(([key, route]) => {
      route.file = winPath(path.resolve(docDir, route.file));
      route.parentId = docLayoutId;
      routes[route.id] = route;
      // 这里存在中英文 转换问题 统一转成hash字符串
      route.path = Md5.hashStr(route.path);
    });
    return routes;
  });
};
