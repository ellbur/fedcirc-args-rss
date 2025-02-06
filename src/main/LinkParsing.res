
module HtmlElement = {
  type t
  
  @send external getElementsByTagName: (t, string) => array<t> = "getElementsByTagName"
  @send external getAttribute: (t, string) => option<string> = "getAttribute"
}

@module("node-html-parser") external parseHTML: string => HtmlElement.t = "parse"

let findMP3URL: string => option<string> = html => {
  let parsed = parseHTML(html)

  let aElems = parsed->HtmlElement.getElementsByTagName("a")

  let mapFind: (array<'a>, 'a => option<'b>) => option<'b> = (arr, f) => {
    let rec iter: int => option<'b> = i => {
      if i < arr->Js.Array2.length {
        switch f(arr[i]->Option.getExn) {
          | Some(x) => Some(x)
          | None => iter(i + 1)
        }
      }
      else {
        None
      }
    }
    iter(0)
  }

  aElems->mapFind(elem => {
    elem->HtmlElement.getAttribute("href")->Belt.Option.flatMap(href => {
      if href->Js.String2.endsWith(".mp3") {
        Some(href)
      }
      else {
        None
      }
    })
  })
}

