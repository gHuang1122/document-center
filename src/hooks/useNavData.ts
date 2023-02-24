import { RouteType } from "@/types/routes";
import { generageRoutes, getImgFilesBypath } from "@/utils/routes";
import { useAppData } from "umi";

/**
 * hook for get nav data
 */

export const useNavData = () => {
  // 获取全局路由信息
  const { routes } = useAppData();

  // 获取/docs下的路由信息
  const localeDocRoutes: any[] = Object.values(routes).filter(
    (item) => item.id !== "@@/global-layout"
  );
  // 获取导航信息
  const nav: RouteType[] = [];

  Object.values(localeDocRoutes).forEach((route: RouteType) => {
    nav.push({
      ...route,
      title: route.id!,
      link: "/" + route.path,
    });
  });

  // 生成嵌套路由
  const newNavRoutes = generageRoutes(nav);

  // 将路由数据注入window中
  const wd: any = window;
  // wd.$routes = newNavRoutes;
  wd.$loadImgSrc = (img: HTMLImageElement) => {
    const alt = img.alt;
    const pathName = location.pathname;
    const imageFiles = getImgFilesBypath(pathName, newNavRoutes);
    imageFiles.forEach((item) => {
      if ((item.imageName = alt)) {
        img.src = item.imageBase64;
      }
    });
    // console.log(imageFiles);
    console.log(`加载图片${alt}`);
  };
  return newNavRoutes;
};
