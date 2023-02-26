/**
 * @auth Breezy
 * @create_time 2023-2-23
 */

import { ImageType } from '@/types/imageType'
import { RouteType } from '@/types/routes'
import { getConfig } from './config'

/**
 * @desc 路由生成函数
 * @param oRoutes
 * @returns
 */
export const generageRoutes = (oRoutes: RouteType[]) => {
  const routes = generateUtil(oRoutes, oRoutes)
  return routes
}

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
  prev: string = ''
) => {
  const routes: RouteType[] = []
  const map = new Map()
  oRoutes.forEach((item) => {
    let routeObj: RouteType = {
      title: item.title,
    }
    const titles = item.title.split('/')
    const title0 = titles[0].replace(/\[\d|_\d*\]/g, '')
    const key: string = `${prev}/${title0}`
    if (!map.has(key)) {
      const childrenTitlesArr: RouteType[] = []
      originData.forEach((el) => {
        const elTitle = el.title.replace(/\[\d|_\d*\]/g, '')
        let rex = new RegExp(`^${key}`)
        let step = ''
        if (/^\//.test(key)) {
          step = '/'
        }
        if (rex.test(step + elTitle)) {
          const len = key.match(/\//g)?.length

          const cTitiles = el.title.split('/').splice(len!).join('/')

          if (cTitiles) {
            childrenTitlesArr.push({
              ...el,
              title: cTitiles,
            })
          }
        }
      })
      if (titles.length == 1) {
        routeObj = {
          ...item,
          // title: title0,
          title: titles[0],
        }
      } else {
        let indexRoute = {}
        const children = generateUtil(childrenTitlesArr, oRoutes, key).filter(
          (c) => {
            if (c.title.includes('index')) {
              indexRoute = { ...c }
            }
            return !c.title.includes('index')
          }
        )

        routeObj = {
          ...indexRoute,
          title: titles[0],
          children,
        }
      }
      const { title } = routeObj
      const { order, show, title: newTitle } = getConfig(title)

      if (show) {
        routes.push({
          ...routeObj,
          order,
          title: newTitle,
          oldTitle: title,
        })
      }
      map.set(key, key)
    }
  })
  return routes.sort((a, b) => b.order! - a.order!)
}

/**
 * 根据 path 匹配路由 imgeFiles
 */
export const getImgFilesBypath = (path: string, oRoutes: RouteType[]) => {
  let imageFiles: ImageType[] = []
  routeRecutil(oRoutes, (item) => {
    if (path == item.path && item.extra?.imageFiles) {
      imageFiles = item.extra.imageFiles
    }
  })
  return imageFiles
}

/**
 * 路由递归函数
 */
type callBackType = (route: RouteType) => void
export const routeRecutil = (oRoutes: RouteType[], callBack: callBackType) => {
  oRoutes.forEach((item) => {
    callBack(item)
    if (item.children?.length) {
      routeRecutil(item.children, callBack)
    }
  })
}

/**
 *  寻找父级路由
 *  @param cPath 当前路由path
 *  @param hie 级别
 *  @param routes 路由数据
 */
export const findFaRoutes: any = (cPath: string, routes: RouteType[] = []) => {
  const arr: RouteType[] = []
  routes.forEach((item) => {
    if (item.path == cPath) {
      arr.push(item)
    } else if (item.children?.length) {
      const children = findFaRoutes(cPath, item.children)
      if (children.length) {
        arr.push({
          ...item,
          children,
        })
      }
    }
  })
  return arr
}
