import { IRouteComponentProps, Link } from 'umi';
import styles from './index.less';

const LayoutComp = (props: IRouteComponentProps) => {
  const { routes, children } = props;
  console.log(routes);
  return (
    <section className={styles.main}>
      <ul className={styles.aside}>
        {routes.map((item, index) => (
          <li key={index}>
            <Link to={item.path}>{item.path}</Link>
            {item.routes?.map((route) => (
              <div key={route.path}>
                <Link to={route.path}>{route.path}</Link>
              </div>
            ))}
          </li>
        ))}
      </ul>
      <section className={styles.content}>{children}</section>
    </section>
  );
};

export default LayoutComp;
