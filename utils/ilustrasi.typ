#import "util.typ": asset

#let gambar(path, ..args) = {
  image(asset("gambar/" + path), ..args)
}

#let tabel(headers: (), columns: 2, ..rows) = {
  show table.cell: it => {
    set text(size: 11pt)
    if it.y > 0 {
      align(left, it)
    } else {
      align(center, strong(it))
    }
  }
  table(
    stroke: (x: none, y: none),
    columns: columns,
    inset: 0.525em,
    table.hline(stroke: 0.5pt + black),
    table.header(..headers),
    table.hline(stroke: 0.5pt + black),
    ..rows,
    table.hline(stroke: 0.5pt + black),
  )
}
