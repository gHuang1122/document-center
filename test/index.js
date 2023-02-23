const originData = [
  "test1/test1-1/test1-1-1",
  "test1/test1-1/test1-1-2",
  "test1/test1-2/test1-2-1",
  "test2/test2-1/test2-1-1",
  "test3/test3-1",
];

const temp = [
  {
    title: "test1",
    children: [
      {
        title: "test1-1",
        children: [
          {
            title: "test1-1-1",
          },
          {
            title: "test1-1-2",
          },
        ],
      },
      {
        title: "test1-2",
        children: [
          {
            title: "test1-2-1",
          },
        ],
      },
    ],
  },
];

function fun(arr, prev = "") {
  const newArr = [];
  const map = new Map();
  arr.forEach((item) => {
    const titles = item.split("/");
    const key = `${prev}/${titles[0]}`;
    if (!map.has(key)) {
      // let childrenTitlesArr = titles.splice(1);
      const childrenTitlesArr = [];
      originData.forEach((el) => {
        let rex = new RegExp(`^${key}`);
        let step = "";
        if (/^\//.test(key)) {
          step = "/";
        }
        if (rex.test(step + el)) {
          const len = key.match(/\//g).length;
          const cTitiles = el.split("/").splice(len).join("/");
          if (cTitiles) {
            childrenTitlesArr.push(cTitiles);
          }
        }
      });
      newArr.push({
        title: titles[0],
        children: fun(childrenTitlesArr, key),
      });
      map.set(key, key);
    }
  });
  return newArr;
}

// 生成二维数组
function generateEr(arr) {
  const newArr = [];
  const obj = new Map();
  arr.forEach((item) => {
    const first = item.split("/")[0];
    const rex = new RegExp(`^${first}`);
    if (!obj.has(first)) {
      const tempArr = arr.filter((el) => rex.test(el));
      newArr.push(tempArr);
      obj.set(first, first);
    }
  });
  return newArr;
}

function main() {
  // const newArr = generateEr(arr);
  // const objArr = newArr.map((item) => fun(item));
  const objArr = fun(originData);
  console.log(JSON.stringify(objArr, null, 2));
}

main();
