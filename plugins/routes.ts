import path from 'path';
import type { IApi } from 'umi';
import type { IRoute } from '@umijs/core/dist/types';
import { getConventionRoutes } from '@umijs/core';

export default (api: IApi) => {
  api.describe({ key: 'domi:routes' });

  api.modifyRoutes((oRoutes: Record<string, IRoute>) => {
    const routes: Record<string, IRoute> = {}

    const docDir = 'docs'
    // 获取某个目录下所有可以配置成umi约定路由的文件
    const dirRoutes: Record<string, IRoute> = getConventionRoutes({
      base: path.join(api.cwd, docDir),
    });

    // 默认提供的布局layout的Id
    let docLayoutId : undefined | string = '@@/global-layout';
    // 从旧路由对象中获取放入返回值中
    routes[docLayoutId] = oRoutes[docLayoutId]

    Object.entries(dirRoutes).forEach(([key, route]) => {
      // 这里将文件的路径改为绝对路径，否则umi会默认找/src/pages下组件
      route.file = path.resolve(docDir, route.file);
      // 给页面对象赋值布局Id
      route.parentId = docLayoutId
      routes[route.id] = route;
    });

    return routes;
  });
};