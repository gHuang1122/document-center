import { getImgFilesBypath } from './routes'

export const wd: any = window

// 图片加载
wd.$loadImgSrc = (img: HTMLImageElement) => {
  const alt = img.alt
  const pathName = location.pathname
  const imageFiles = getImgFilesBypath(pathName, wd.$routes)
  imageFiles.forEach((item) => {
    if ((item.imageName = alt)) {
      img.src = item.imageBase64
    }
  })
  console.warn(`加载图片${alt}`)
}

// md文件跳转
wd.$goMdFile = (mdPath: string) => {}
