import { ImageType } from "./imageType";

export type RouteType = {
  title: string;
  link?: string;
  order?: number;
  children?: RouteType[];
  redirect?: string;
  id?: string;
  path?: string;
  extra?: {
    imageFiles: ImageType[];
  };
};
