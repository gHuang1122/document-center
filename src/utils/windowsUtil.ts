import { getImgFilesBypath, routeRecutil } from './routes'
import path from 'path'
import { history } from 'umi'

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
  const fileName = path.basename(mdPath).replace(/\.md/, '')
  const currentRouteurl = path.basename(location.pathname)

  routeRecutil(wd.$routes, (item) => {
    if (item.path == currentRouteurl) {
      if (item.children?.length) {
        routeRecutil(item.children, (e) => {
          if (e.title == fileName) {
            e.link && history.push(e.link)
          }
        })
      }
    }
  })
}
