import { RouteType } from "@/types/routes";
import { history, useLocation } from "umi";
import styles from "./index.less";

type Props = {
  navData?: RouteType[];
};

const AsideList = (props: Props) => {
  const { navData } = props;
  const location = useLocation();

  const handleClick = (link?: string) => {
    if (link) {
      history.push(link);
    }
  };
  if (!navData) {
    return null;
  }
  return (
    <div className={styles.asideCon}>
      {navData!.map((item) => (
        <div key={item.title}>
          <div
            className={`${styles.item} ${item.link ? styles.isLink : ""} ${
              item.link == location.pathname ? styles.active : ""
            }`}
            onClick={() => {
              handleClick(item.link);
            }}
          >
            <span className={styles.step}>{item.link ? "·" : "-"}</span>
            <span>{item.title}</span>
          </div>
          <AsideList navData={item.children} />
        </div>
      ))}
    </div>
  );
};

export default AsideList;
