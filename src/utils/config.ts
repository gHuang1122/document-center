export const getConfig = (name: string) => {
  const rex = /\[.*\]/g
  const rexConfig = /\d_\d*/g
  const dirConfig: string[] = name.match(rexConfig) ?? []
  const dirConfigArr = dirConfig.length ? dirConfig[0].split('_') : []
  const show = +dirConfigArr[0] ?? 1
  const order = +dirConfigArr[1] ?? 0

  return {
    show: isNaN(show) ? 1 : show,
    order: isNaN(order) ? 0 : order,
    title: name.replace(rex, ''),
  }
}
