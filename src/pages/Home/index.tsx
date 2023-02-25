import { history } from 'umi'

const Home = () => {
  const handleClick = () => {
    history.push('/docs')
  }

  return (
    <div>
      <button onClick={handleClick}>文档跳转</button>
    </div>
  )
}

export default Home
