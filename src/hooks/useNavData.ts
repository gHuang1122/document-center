import { RouteType } from '@/types/routes'
import { getConfig } from '@/utils/config'
import { generageRoutes, getImgFilesBypath } from '@/utils/routes'
import { useAppData } from 'umi'

/**
 * hook for get nav data
 */

export const useNavData = () => {
  // 获取全局路由信息
  const { routes } = useAppData()

  // 获取/docs下的路由信息
  const localeDocRoutes: any[] = Object.values(routes).filter(
    (item) => item.id !== '@@/global-layout'
  )
  // 获取导航信息
  const nav: RouteType[] = []

  Object.values(localeDocRoutes).forEach((route: RouteType) => {
    const { show, order } = getConfig(route.id!)
    const bool = route.path == "/" || /^\\/g.test(route.path!)
    const step = bool ? '' : '/'
    if (show) {
      nav.push({
        ...route,
        title: route.id!,
        link:
          route.parentId == '@@/global-layout'
            ? `/docs${step}${route.path}`
            : `${step}${route.path}`,
        order,
      })
    }
  })

  // 生成嵌套路由
  const newNavRoutes = generageRoutes(nav)

  // 将数据注入window中
  const wd: any = window
  wd.$routes = newNavRoutes
  return newNavRoutes
}
