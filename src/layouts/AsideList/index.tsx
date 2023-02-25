import { RouteType } from '@/types/routes'
import { useMemo } from 'react'
import { history, useLocation } from 'umi'
import styles from './index.less'

type Props = {
  navData?: RouteType[]
}

const AsideList = (props: Props) => {
  const { navData } = props
  const location = useLocation()

  const handleClick = (link?: string) => {
    if (link) {
      history.push(link)
    }
  }

  const filterNavData = useMemo(() => {
    // 不展示的路由
    const hiddenLinks = ['/']
    // return navData?.filter((item) => item.parentId == '@@/global-layout') ?? []

    return (
      navData?.filter((item) => !hiddenLinks.includes(item.link ?? '')) ?? []
    )
  }, [navData])

  if (!navData) {
    return null
  }
  return (
    <div className={styles.asideCon}>
      {filterNavData.map((item) => (
        <div key={item.title}>
          <div
            className={`${styles.item} ${item.link ? styles.isLink : ''} ${
              item.link == location.pathname ? styles.active : ''
            }`}
            onClick={() => {
              handleClick(item.link)
            }}
          >
            <span className={styles.step}>{item.link ? '·' : '-'}</span>
            <span>{item.title}</span>
          </div>
          <AsideList navData={item.children} />
        </div>
      ))}
    </div>
  )
}

export default AsideList
