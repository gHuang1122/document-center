import { useAppData } from "umi";

/**
 * hook for get nav data
 */
export const useNavData = () => {
  // 获取全局路由信息
  const { routes } = useAppData();
  // 获取/docs下的路由信息
  const localeDocRoutes: any[] = Object.values(routes).filter(item=> item.id !== "@@/global-layout");
  // 获取导航信息
  const nav: any = [];
  Object.values(localeDocRoutes).forEach((route) => {
    if (route.path == "/") {
      nav.push({
        title: "首页",
        link: "/",
        order: 0,
      });
    } else {
      nav.push({
        title: route.path,
        link: "/" + route.path,
        order: 1,
      });
    }
  });

  return nav.sort((a: any, b: any) => a.order - b.order);
};
