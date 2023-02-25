export const getConfig = (name: string) => {
  const rex = /\[.*\]/g
  // const rexConfig = /\d_\d*/g
  // const dirConfig: string[] = name.match(rexConfig) ?? []
  // const dirConfigArr = dirConfig.length ? dirConfig[0].split('_') : []
  // const show = +dirConfigArr[0] ?? 1
  // const order = +dirConfigArr[1] ?? 0
  const showRex = /\[\d/g
  const orderRex = /_\d*/g
  const show = name.match(showRex)?.[0].substring(1) ?? 1
  const order = name.match(orderRex)?.[0].substring(1) ?? 0

  return {
    show: +show,
    order: +order,
    title: name.replace(rex, ''),
  }
}
