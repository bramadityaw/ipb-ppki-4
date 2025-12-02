#import "util.typ": asset

#let gambar(path, ..args) = {
  image(asset("gambar/" + path), ..args)
}

#let tabel(headers: (), columns: 2, ..rows) = {
  table(
    columns: columns,
    inset: 0.525em,
    table.hline(stroke: 0.5pt + black),
    table.header(..headers),
    table.hline(stroke: 0.5pt + black),
    ..rows,
    table.hline(stroke: 0.5pt + black),
  )
}
