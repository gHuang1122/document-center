import { RouteType } from "@/types/routes";
import { generageRoutes } from "@/utils/routes";
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
      title: route.id!,
      link: "/" + route.path,
    });
  });

  // 生成嵌套路由
  const newNavRoutes = generageRoutes(nav);
  
  return newNavRoutes;
};
