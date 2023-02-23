/**
 * @auth Breezy
 * @create_time 2023-2-23
 * @desc 路由生成帮助函数
 */

import { RouteType } from "@/types/routes";

export const generageRoutes = (oRoutes: RouteType[]) => {
  const routes = generateUtil(oRoutes, oRoutes);
  return routes;
};

export const generateUtil = (
  oRoutes: RouteType[],
  originData: RouteType[],
  prev: string = ""
) => {
  const routes: RouteType[] = [];
  const map = new Map();
  oRoutes.forEach((item) => {
    const titles = item.title.split("/");
    const key: string = `${prev}/${titles[0]}`;
    if (!map.has(key)) {
      const childrenTitlesArr: RouteType[] = [];
      originData.forEach((el) => {
        let rex = new RegExp(`^${key}`);
        let step = "";
        if (/^\//.test(key)) {
          step = "/";
        }
        if (rex.test(step + el.title)) {
          const len = key.match(/\//g)?.length;
          const cTitiles = el.title.split("/").splice(len!).join("/");
          if (cTitiles) {
            childrenTitlesArr.push({
              ...el,
              title: cTitiles,
            });
          }
        }
      });
      if (titles.length == 1) {
        routes.push({
          ...item,
          title: titles[0],
          // children: generateUtil(childrenTitlesArr, oRoutes, key),
        });
      } else {
        routes.push({
          title: titles[0],
          children: generateUtil(childrenTitlesArr, oRoutes, key),
        });
      }
      map.set(key, key);
    }
  });
  return routes;
};

/**
 * 根据 title 匹配路由
 */
export const getRoutesByTitle = () => {};
