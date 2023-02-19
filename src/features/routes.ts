/**
 * @author Breezy
 * @createTime 2023-02-19
 * @description 读取md存放文件夹 动态生成路由
 */

import { IApi, IRoute } from 'umi';
import path from 'path';
import fs from 'fs';

// md 存放路径
const domDir = 'docs';

// 只生成一级路由，嵌套路由暂不考虑
const createRouteFile = async (filePath: string) => {
  const dirs = await fs.promises.readdir(filePath);
  const routes: IRoute[] = [];
  for (const name of dirs) {
    const stat = await fs.promises.stat(path.join(filePath, name));
    const baseName = path.basename(filePath);
    const isDir = stat.isDirectory();
    let route: IRoute = {
      path: `/${name.toLowerCase()}`,
      component: path.join(filePath, name),
      exact: true,
      name: `${name.toLowerCase()}`,
    };
    if (!isDir && /index\.tsx/g.test(name)) {
      route = {
        path: `/${baseName}`,
        name: `${baseName}`,
        component: filePath,
        exact: true,
      };
    }
    routes.push(route);
  }
  return routes;
};

/**
 * @param projectPath 工程文件夹绝对路径
 * @param initialValue 默认路由
 * @returns
 * @description 根据 docs 文件夹下的内容 自动生成路由
 */
export const generateRoutes = async (
  projectPath: string,
  initialValue: IRoute[] = [],
): Promise<IRoute[]> => {
  const readPath = path.join(projectPath, domDir);
  const routes: IRoute[] = await createRouteFile(readPath);
  // return [...initialValue, ...routes];
  // return [{ ...initialValue, routes: [...routes] }];
  return [
    {
      ...initialValue[0],
      routes,
    },
  ];
};

export default (api: IApi) => {
  api.describe({ key: 'domi:routes' });
  api.modifyRoutes(async (initialValue: IRoute[]) => {
    const routes: IRoute[] = await generateRoutes(api.cwd, initialValue);
    return routes;
  });
};
