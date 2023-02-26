import { findFaRoutes, getImgFilesBypath, routeRecutil } from './routes'
import path from 'path'
import { history } from 'umi'
import { RouteType } from '@/types/routes'
import { Md5 } from 'ts-md5'

export const wd: any = window

// 图片加载
wd.$loadImgSrc = (img: HTMLImageElement) => {
  // 参数过滤
  const configRex = /\[.*\]/g
  const alt = img.alt.replace(configRex, '')

  const pathName = location.pathname
  const imageFiles = getImgFilesBypath(path.basename(pathName), wd.$routes)

  imageFiles.forEach((item) => {
    if ((item.imageName = alt)) {
      img.src = item.imageBase64
    }
  })
  console.warn(`加载图片${alt}`)
}

// md文件跳转
wd.$goMdFile = (a: HTMLElement) => {
  const mdPath = a.getAttribute('data-mdpath') ?? ''
  const currentRouteurl = path.basename(location.pathname)

  const routes = findFaRoutes(currentRouteurl, wd.$routes)

  const titles: string[] = []
  routeRecutil(routes, (item) => {
    if (item.oldTitle && item.children?.length == 1) {
      titles.push(item.oldTitle)
    }
  })
  if (titles.length == 0) {
    titles.push(routes[0].oldTitle)
  }
  const originPath = path.join(titles.join('/'), mdPath).replace(/\.md/g, '')
  const link = Md5.hashStr(originPath)
  if (link) {
    history.push(link)
  }
}
