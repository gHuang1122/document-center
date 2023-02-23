import { useNavData } from "@/hooks/useNavData";
import { history, Outlet } from "umi";
import styles from "./index.less";
import "../global.less";

export default function Layout() {
  const nav = useNavData();
  const handleClick = (link: string) => {
    history.push(link);
  };

  return (
    <section className={styles.main}>
      <aside className={styles.aside}>
        <ul>
          {nav.map((item: any) => (
            <li
              key={item.link}
              onClick={() => {
                handleClick(item.link);
              }}
            >
              {item.title}
            </li>
          ))}
        </ul>
      </aside>
      <section className={`${styles.content} markdown-body`}>
        <Outlet />
      </section>
      <nav className={styles.nav}></nav>
    </section>
  );
}
