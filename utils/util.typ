#let content-to-string(it) = {
  if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(content-to-string).join(" ")
  } else if it.has("body") {
    content-to-string(it.body)
  } else if it == [] {
    " "
  }
}

#let asset(path) = "/template/asset/" + path
