function mdLoader(content) {
  return `
    import react from 'react'
    const content = ${JSON.stringify(content)};
    const Markdown = () => {
        return (<div>{content}</div>)
    }
    export default Markdown
  `;
}
module.exports = mdLoader
