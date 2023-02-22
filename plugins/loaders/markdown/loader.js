const Mk = require("marked");

function mdLoader(content) {
  const html = JSON.stringify(Mk.parse(content));
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
