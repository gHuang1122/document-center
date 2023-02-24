import path from "path";
import type { IApi } from "umi";
import type { IRoute } from "@umijs/core/dist/types";
import { getConventionRoutes } from "@umijs/core";
import { winPath } from "umi/plugin-utils";
import { Md5 } from "ts-md5";
import { generateImageFiles } from "./utils/imageGen";

export default (api: IApi) => {
  api.describe({ key: "doc:routes" });

  api.modifyRoutes(async (oRoutes: Record<string, IRoute>) => {
    const routes: Record<string, IRoute> = {};
    const docDir = "docs";
    const dirRoutes: Record<string, IRoute> = getConventionRoutes({
      base: path.join(api.cwd, docDir),
    });

    // 默认提供的布局layout的Id
    let docLayoutId: undefined | string = "@@/global-layout";
    routes[docLayoutId] = oRoutes[docLayoutId];
    for (const [key, route] of Object.entries(dirRoutes)) {
      route.file = winPath(path.resolve(docDir, route.file));
      route.parentId = docLayoutId;
      routes[route.id] = route;
      // 将中英文  统一转成hash字符串
      route.path = Md5.hashStr(route.path);
      // 额外参数
      route.extra = {
        imageFiles: await generateImageFiles(route.file),
      };
    }
    return routes;
  });
};
