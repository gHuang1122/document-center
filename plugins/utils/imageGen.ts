/**
 *  根据路径 生成 image base64
 *  默认图片保存路径为 img 文件夹，和md文件属于同级
 */

import { ImageType } from "@/types/imageType";
import path from "path";
import fs from "fs";

export const generateImageFiles = async (mdPath: string) => {
  const imgDirPath = path.join(mdPath, "../img");
  const imgFiles: ImageType[] = [];
  try {
    const dirs = await fs.promises.readdir(path.dirname(mdPath));
    if (dirs.includes("img")) {
      const dirContent = await fs.promises.readdir(imgDirPath);
      for (const fileName of dirContent) {
        const filePath = path.join(imgDirPath, fileName);
        const stat = await fs.promises.stat(filePath);
        if (stat.isFile()) {
          const file = await fs.promises.readFile(filePath);
          const base64 = Buffer.from(file).toString("base64");
          imgFiles.push({
            imageName: fileName.replace(/\..*/, ""),
            imageBase64: `data:image/png;base64,${base64}`,
          });
        }
      }
    }
  } catch (error) {
    console.log(error);
  }
  return imgFiles;
};
