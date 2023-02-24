import { useNavData } from "@/hooks/useNavData";
import { history, Outlet } from "umi";
import styles from "./index.less";
import "../global.less";
import AsideList from "./AsideList";

export default function Layout() {
  const nav = useNavData();
  
  return (
    <section className={styles.main}>
      <aside className={styles.aside}>
        <AsideList navData={nav} />
      </aside>
      <section className={`${styles.content} markdown-body`}>
        <Outlet />
      </section>
      {/* <nav className={styles.nav}></nav> */}
    </section>
  );
}
