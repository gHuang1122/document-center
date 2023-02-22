import { useNavData } from "@/hooks/useNavData";
import { history, Link, Outlet } from "umi";
import styles from "./index.less";
import "../global.less";
import { useMemo } from "react";

export default function Layout() {
  const nav = useNavData();
  console.log(nav);
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
