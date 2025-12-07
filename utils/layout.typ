#import "/utils/util.typ": content-to-string, asset
#import "/utils/ilustrasi.typ": gambar
#let bab(body) = [
  #pagebreak()
  #let label-name = lower(content-to-string(body).split(" ").join("-"))
  #heading(body, numbering: "I", supplement: [Bab], level: 1)
  #label(label-name)
]

#let judul(body) = {
  set text(size: 14pt)
  set align(center)
  set par(justify: false)
  strong(upper(body))
  v(1em)
}

#let ppki(
  body,
  bahasa: "id",
  judul-tugas-akhir: [],
  penulis: "",
  proposal: true,
  nim: [],
  bab-bab: (),
  prodi: [],
  kaprodi: (nama: [], npi: []),
  dosbing2: (),
  jenjang: "diploma",
  gelar: "Sarjana Terapan",
  tanggal-presentasi: datetime.today(),
  bib: asset("foo.bib"),
  ringkasan: (
    narasi: lorem(50),
    kata-kunci: lorem(4).split(" ").map(lower),
  ),
  prakata: lorem(50),
  daftar-isi: true,
) = {
  if not daftar-isi and jenjang != "magang" { panic("Daftar isi opsional hanya untuk laporan magang") }
  set document(
    title: judul-tugas-akhir,
    author: penulis,
  )
  set page(
    paper: "a4",
    margin: (outside: 4cm, inside: 3cm, y: 3cm),
    numbering: "i",
    footer: none,
  )
  set text(
    font: "Times New Roman",
    size: 12pt,
    lang: bahasa,
    spacing: 0.15em,
  )
  show raw: set text(font: "Courier New")
  set par(
    justify: true,
    first-line-indent: (
      amount: 1cm,
      all: true,
    ),
    spacing: 0.5em,
    leading: 0.5em,
  )

  show figure: set par(spacing: 1.5em)
  set figure.caption(separator: h(0.125em))

  let logo-ipb = gambar("logo-ipb-new.png", width: 2.5cm, height: 2.5cm)

  // Halaman Sampul
  align(center, text(14pt, strong(upper([
    #v(2em)
    #block(width: 4.5in)[
      #set par(justify: false)
      #judul-tugas-akhir
    ]
    #v(12em)
    #penulis
    #v(10em)
    #logo-ipb
    #v(8em)
    #prodi

    Sekolah Vokasi

    Institut Pertanian Bogor

    Bogor

    #datetime.today().year()
  ]))))

  pagebreak(to: if jenjang == "magang" { "even" } else { "odd" } )

  let jenis-tugas-akhir(jenjang) = {
    if jenjang == "diploma" { "Laporan Proyek Akhir" }
    else if jenjang == "magang" { "Laporan Magang" }
    else  { panic("Jenjang " + jenjang + " belum didukung") }
  }

  for section in (
  // Halaman Pernyataan
  [
    #judul[
      PERNYATAAN MENGENAI #upper(jenis-tugas-akhir(jenjang)) DAN SUMBER INFORMASI SERTA PELIMPAHAN HAK CIPTA
    ]

    #v(1em)
    Dengan ini saya menyatakan bahwa #lower(jenis-tugas-akhir(jenjang)) dengan judul “#judul-tugas-akhir” adalah karya saya dengan arahan dari dosen
    pembimbing dan belum diajukan dalam bentuk apapun kepada perguruan tinggi mana pun.
    Sumber informasi yang berasal atau dikutip dari karya yang diterbitkan maupun tidak
    diterbitkan dari penulis lain telah disebutkan dalam teks dan dicantumkan dalam Daftar
    Pustaka di bagian akhir #lower(jenis-tugas-akhir(jenjang)) ini.

    Dengan ini saya melimpahkan hak cipta dari karya tulis saya kepada Institut
    Pertanian Bogor.

    #align(right)[
      #set par(justify: false)
      Bogor, #datetime.today().display("[month repr:long] [year repr:full]")
      #v(3em)
      #penulis

      #nim
    ]
  ],
  // Halaman Hak Cipta
  [
    #set align(bottom)
    #set text(size: 14pt)

    #align(center)[
      $copyright$ Hak Cipta milik IPB, tahun #datetime.today().year()

      Hak Cipta dilindungi Undang-Undang
    ]
    #v(1em)
    #set text(size: 12pt)

    #align(center, block(width: 5.375in)[
      #set align(left)
      _Dilarang mengutip sebagian atau seluruh karya tulis ini tanpa
      mencantumkan atau menyebutkan sumbernya. Pengutipan hanya untuk
      kepentingan pendidikan, penelitian, penulisan karya ilmiah, penyusunan laporan,
      penulisan kritik, atau tinjauan suatu masalah, dan pengutipan tersebut tidak
      merugikan kepentingan IPB._

      #v(1em)

      _Dilarang mengumumkan dan memperbanyak sebagian atau seluruh karya
      tulis ini dalam bentuk apa pun tanpa izin IPB._
    ])
  ],
  if not proposal [
    #let remove-titles(name) = {
      let titles = regex(
        "Prof\.\s*|Dr\.\s*|Ir\.\s*|Dra\.\s*|Drs\.\s*|" +
        "(?:H|Hj)\.\s*|" +
        "Sp\.[A-Z]+(?:\([^)]*\))?,?\s*|" +
        "M\.[A-Za-z]+\.\s*|S\.[A-Za-z]+\.\s*|" +
        "Ph\.D\.\s*|D\.[A-Z]+\.\s*|" +
        "Ns\.\s*|Psikolog\.\s*|" +
        ",?\s*(?:[A-Z]\.)+\s*$"
      )

      let without-titles = name.replace(titles, "")

      without-titles
        .replace(regex("^\s*,\s*|\s*,\s*"), "")
        .replace(regex("\s+"), " ")
        .trim()
    }
    #judul[Ringkasan]
    #let pembimbing = if type(dosbing2)== content {
      upper(remove-titles(content-to-string(dosbing2)))
    } else if type(dosbing2) == array {
      dosbing2.map(x => upper(content-to-string(x))).join(", ", last: ", dan ")
    }

    #upper(penulis). #judul-tugas-akhir. Dibimbing oleh #pembimbing.

    #ringkasan.narasi

    Kata kunci: #ringkasan.kata-kunci.join(", ")
  ],
  // Halaman Judul
  [
    #align(center)[
      #text(14pt, strong(upper([
        #v(2em)
        #block(width: 4.5in)[
          #set par(justify: false)
          #judul-tugas-akhir
        ]
        #v(8em)
        #penulis
      ])))

      #v(8em)
      #block(width: 4.5in)[
        #jenis-tugas-akhir(jenjang)
        #if jenjang != "magang" [
          sebagai salah satu syarat untuk memperoleh gelar

          #gelar pada

          Program Studi #prodi
        ]
      ]

      #v(18em)
      #text(14pt, strong(upper([
        #prodi

        Sekolah Vokasi

        Institut Pertanian Bogor

        Bogor

        #datetime.today().year()
      ])))
    ]
  ],
  // Halaman Pengesahan
  [
    #set par(first-line-indent: 0pt)

    #grid(
      columns: (9.6em, 0.5em, 2fr),
      row-gutter: 0.5em,
      [Judul #jenis-tugas-akhir(jenjang)],[:], [#judul-tugas-akhir],
      [Nama],[:],[ #penulis],
      [NIM],[:],[ #nim],
    )

    #v(6em)

    #align(center)[Disetujui oleh]

    #if type(dosbing2) == content [
      Pembimbing :

      #grid(
        columns: (1em, 18em, 5.5em, 100%),
        none, dosbing2, none,
        grid.cell(align: horizon, rowspan: 2, line(length: 9em)),
        none, none, none,
      )
    ] else if type(dosbing2) == array {
      for (i, dosbing) in dosbing2.enumerate() [
        Pembimbing #(i + 1) :

        #grid(
          columns: (1em, 18em, 5.5em, 100%),
          none, dosbing, none,
          grid.cell(align: horizon, rowspan: 2, line(length: 9em)),
          none, none, none,
        )
      ]
    } else {
      panic([dosbing2 harus berupa content atau array, malah berupa #type(dosbing2)])
    }
    #v(10em)

    #align(center)[Diketahui oleh]

    Ketua Program Studi :

    #grid(
      columns: (1em, 20em, 3.5em, 100%),
      row-gutter: 0.5em,
      none, kaprodi.nama, none,
      grid.cell(align: horizon, rowspan: 2, line(length: 9em)),
      none, [NPI. ] + kaprodi.npi, none, none,
    )
    #align(bottom)[
      Tanggal Presentasi:

      #tanggal-presentasi.display("[day padding:none]-[month repr:long]-[year repr:full]")
    ]
  ],
  [
    #judul[Prakata]

    #prakata

    #align(right)[
      #set par(justify: false)
      Bogor, #datetime.today().display("[month repr:long] [year repr:full]")
      #v(3em)
      _#(penulis)_
    ]
  ],
  ) {
    section
    pagebreak()
  }

  [
    #show outline: it => {
      set heading(outlined: true)
      set outline.entry(fill: none)
      show heading: h => {
        set align(center)
        set text(14pt)
        upper(h)
      }
      show outline.entry: e => {
        show cite: it => none
        let loc = e.element.location()
        if e.level == 1 {
          set block(above: 1.2em)
          let entry = [
            #let f = if e.element.func() == heading { upper } else { it => it }
            #f(content-to-string(e.body()).replace(regex("\(.*?\)"), ""))
            #box(width: 1fr, e.fill)
            #e.page()
          ]
          link(
          loc,
            e.indented(
              if e.element.func() == figure {
                numbering(
                  e.element.numbering,
                  ..counter(figure.where(kind: e.element.kind)).at(loc),
                )
              } else {
                e.prefix()
              },
              entry,
            )
          )
        } else if e.level == 2 {
          link(loc, e)
        }
      }

      let entries = query(it.target)
      if entries.len() >= 2 {
        it
      }
    }

    #outline()

    #let figure-kinds = (image, table, "lampiran")

    #for (kind, title) in figure-kinds.zip(
      ([Daftar Gambar], [Daftar Tabel], [Daftar Lampiran])
    ) {
      outline(title: title, target: figure.where(kind: kind))
    }
  ]

  set page(
    numbering: "1",
    header: context {
      let n = here().page();
      let matches = query(heading.where(supplement: [Bab]))
      let alignment = if calc.even(n) { left } else { right }
      if not matches.any(m => m.location().page() == n) {
        align(alignment, [#n])
      }
    }
  )

  set heading(numbering: "1.1.1")
  show heading: it => {
    set par(
      justify: false,
      first-line-indent: (
        amount: 0cm,
        all: true,
      ),
    )
    set text(if it.level == 1 { 14pt } else { 12pt })
    set align(center) if it.level == 1
    let num-pat = if it.level == 1 {"I"} else {"1.1.1"}
    let text-weight = if it.level > 2 { "regular" } else { "bold" }
    if it.level >= 2 { v(0.75em) }
    let header-count = counter(heading).get().at(0)
    text(
      weight: text-weight,
      if header-count != 0 {
        numbering(num-pat, ..counter(heading).get())
      }
    )
    box(width: 1em)
    let body = if it.level == 1 { upper(it.body) } else { it.body }
    text(weight: text-weight, body)
    v(0.5em)
  }

  set enum(
    numbering: "a",
    indent: 0em,
    body-indent: 1.5em,
  )

  set list(
    indent: 0em,
    body-indent: 2em,
  )

  show figure.where(kind: table): it => {
    set figure(gap: 3pt)
    set par(justify: true, first-line-indent: 0em, spacing: 3pt)
    show par: set align(left)
    set figure.caption(position: top)
    it
  }

  counter(page).update(1)

  body

  if daftar-isi {
    show heading: it => {
      pagebreak()
      set par(justify: false)
      set text(if it.level == 1 { 14pt } else { 12pt })
      align(center, upper(it.body))
      if it.level == 1 { v(1.5em) } else { v(1em) }
    }
    bibliography(bib, style: asset("ipb.csl"))
  }

  if (context query(figure.where(kind: "lampiran")).len() > 0) == [#true] {
    pagebreak()
    {
      counter(heading).update(0)
      set page(header: none, margin: (left: 3cm))
      set heading(numbering: none)

      align(center + horizon)[
        = Lampiran
      ]
      pagebreak()

      set heading(numbering: none, outlined: false)
      let lampiran = figure.with(kind: "lampiran", supplement: [Lampiran])
      show figure.where(kind: "lampiran"): it => {
        set heading(numbering: "1", supplement: [Lampiran])
        show heading: it => {
          set par(justify: true)
          set text(12pt, weight: "regular")
          set align(left)
          it
        }

        set figure.caption(position: top)
        set align(left)
        set par(justify: true, first-line-indent: 0em)
        it
      }
    }
  }
}
