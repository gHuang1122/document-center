export const getConfig = (name: string) => {
  const rex = /\[.*\]/g
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
