import path from 'path'
import type { IApi } from 'umi'
import type { IRoute } from '@umijs/core/dist/types'
import { getConventionRoutes } from '@umijs/core'
import { winPath } from 'umi/plugin-utils'
import { Md5 } from 'ts-md5'
import { generateImageFiles } from './utils/imageGen'

export default (api: IApi) => {
  api.describe({ key: 'doc:routes' })

  api.modifyRoutes(async (oRoutes: Record<string, IRoute>) => {
    const routes: Record<string, IRoute> = {}
    const homeRoute = oRoutes['1']
    const docDir = 'docs'
    const dirRoutes: Record<string, IRoute> = getConventionRoutes({
      base: path.join(api.cwd, docDir),
    })
    // console.log(dirRoutes);

    // 默认提供的布局layout的Id
    let docLayoutId: undefined | string = '@@/global-layout'
    routes[docLayoutId] = {
      ...oRoutes[docLayoutId],
      path: '/docs',
      absPath: '/docs',
    }

    for (const [key, route] of Object.entries(dirRoutes)) {
      route.file = winPath(path.resolve(docDir, route.file))
      route.parentId = docLayoutId
      // 将中英文  统一转成hash字符串
      route.path = Md5.hashStr(route.path)
      // 额外参数
      route.extra = {
        imageFiles: await generateImageFiles(route.file),
      }
      routes[route.id] = route
    }

    // 配置home路由
    const { id, file, path: hp } = homeRoute
    routes[id] = { id, file, path: hp, absPath: hp }

    // 配置404路由

    
    return routes
  })
}
