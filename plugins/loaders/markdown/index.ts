export default function mdLoader(this: any, content: string) {
  return `
        import react from 'react'
        const content = ${JSON.stringify(content)};
        const Markdown = () => {
            return (<div>{content}</div>)
        }
        export default Markdown
    `;
}
