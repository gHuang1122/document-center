const { marked } = require("marked");
const hljs = require("highlight.js");

const rendererMD = new marked.Renderer();

// 超链接 [接口授权1](./接口授权1.md) => [args[2]](args[0])
rendererMD.link = (...args) => {
  // 判断是否为 相对路径的md文件
  const mdRex = /\..*\.md/g;
  if (mdRex.test(args[0])) {
    return `<a onclick="$goMdFile(this)" data-mdpath="${args[0]}">${args[2]}</a>`;
  } else {
    return `<a href='${args[0]}' target="_blank">${args[2]}</a>`;
  }
};

// 图片  ![testimage[width:300px;height:300px]](./img/testimage.png) => ![args[2]](args[0])
rendererMD.image = (...args) => {
  const rex = /^\./g;
  let style = "";
  try {
    style = args[2].match(/\[.*\]/g)[0].replace(/\]|\[/g, "");
  } catch (error) {

  }
  if (rex.test(args[0])) {
    // 本地图片
    return `<img src="" onerror="$loadImgSrc(this)" style="${style}" alt="${args[2]}" />`;
  } else {
    // 网络图片
    return `<img src="${args[0]}" style="${style}" alt="${args[2]}" />`;
  }
};

marked.setOptions({
  renderer: rendererMD,
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  smartypants: true,
  highlight: function (code) {
    return hljs.highlightAuto(code).value;
  },
});

function mdLoader(content) {
  const html = JSON.stringify(marked(content));
  return `
    import react from 'react';
    const content = ${html};
    const Markdown = () => {
        return (<div dangerouslySetInnerHTML={{
          __html:content
        }}></div>);
    }
    export default Markdown;
  `;
}
module.exports = mdLoader;
