/**
 * @auth Breezy
 * @create_time 2023-2-23
 */

import { ImageType } from "@/types/imageType";
import { RouteType } from "@/types/routes";

/**
 * @desc 路由生成函数
 * @param oRoutes
 * @returns
 */
export const generageRoutes = (oRoutes: RouteType[]) => {
  const routes = generateUtil(oRoutes, oRoutes);
  return routes;
};

/**
 * @desc 路由生成辅助函数
 * @param oRoutes
 * @param originData
 * @param prev
 * @returns
 */
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
 * 根据 path 匹配路由 imgeFiles
 */
export const getImgFilesBypath = (path: string, oRoutes: RouteType[]) => {
  let imageFiles: ImageType[] = [];
  routeRecu(oRoutes, (item) => {
    if (path == "/" + item.path && item.extra?.imageFiles) {
      imageFiles = item.extra.imageFiles;
    }
  });
  return imageFiles;
};

/**
 * 路由递归函数
 */
type callBackType = (route: RouteType) => void;
export const routeRecu = (oRoutes: RouteType[], callBack: callBackType) => {
  oRoutes.forEach((item) => {
    if (item.children?.length) {
      routeRecu(item.children, callBack);
    } else {
      callBack(item);
    }
  });
};
