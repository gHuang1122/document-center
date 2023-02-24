const nameRex = /\[.*\]/g;
const pathRex = /\(.*\)/g;
const str = "![image-20210507102533833](./img/image-20210507102533833.png)";
const imgName = str.match(nameRex)[0];
const imgPath = str.match(pathRex)[0];

console.log(imgName, imgPath);
