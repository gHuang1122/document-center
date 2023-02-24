const { marked } = require("marked");
const hljs = require("highlight.js");

const rendererMD = new marked.Renderer();

// 超链接
rendererMD.link = (...args) => {
  return `<a href='${args[0]}' target="_blank">${args[2]}</a>`;
};

// 图片
rendererMD.image = (...args) => {
  return `<img src="" onerror="$loadImgSrc(this)" alt="${args[2]}" />`;
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
