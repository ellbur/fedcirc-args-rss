
open Model

type axiosRes = {
  responseUrl: string
}

type axiosBackRequest = {
  res: axiosRes
}

type axiosResponse<'a> = {
  data: {..} as 'a,
  request: axiosBackRequest
}

@module("axios") external axiosPost: (string, string) => Promise.t<axiosResponse<'a>> = "post"

type htmlElement = {
  text: string
}
@module("node-html-parser") external parseHTML: string => htmlElement = "parse"
@send external getElementsByTagName: (htmlElement, string) => array<htmlElement> = "getElementsByTagName"
@send external getAttribute: (htmlElement, string) => string = "getAttribute"

let parseSlashesMDY = text =>
  switch Js.String2.split(text, "/") {
    | [mStr, dStr, yStr] => {
      year: yStr->Belt.Int.fromString->Belt.Option.getExn,
      month: mStr->Belt.Int.fromString->Belt.Option.getExn,
      day: dStr->Belt.Int.fromString->Belt.Option.getExn
    }
    | _ => Js.Exn.raiseError(`Invalid date format: ${text}`)
  }

let listArgs = () =>
  axiosPost(
    "https://cafc.uscourts.gov/wp-admin/admin-ajax.php?action=get_wdtable&table_id=8",
    "draw=1&columns%5B0%5D%5Bdata%5D=0&columns%5B0%5D%5Bname%5D=Arg_Date&columns%5B0%5D%5Bsearchable%5D=true&columns%5B0%5D%5Borderable%5D=true&columns%5B0%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B0%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B1%5D%5Bdata%5D=1&columns%5B1%5D%5Bname%5D=Appeal_Number&columns%5B1%5D%5Bsearchable%5D=true&columns%5B1%5D%5Borderable%5D=true&columns%5B1%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B1%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B2%5D%5Bdata%5D=2&columns%5B2%5D%5Bname%5D=Arg_Link&columns%5B2%5D%5Bsearchable%5D=true&columns%5B2%5D%5Borderable%5D=true&columns%5B2%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B2%5D%5Bsearch%5D%5Bregex%5D=false&order%5B0%5D%5Bcolumn%5D=0&order%5B0%5D%5Bdir%5D=desc&start=0&length=25&search%5Bvalue%5D=&search%5Bregex%5D=false&wdtNonce=7d20cef338"
  )->Promise.thenResolve(resp => {
    resp.data["data"]->Js.Array2.map(entry => {
      let html = parseHTML(entry[2])
      let a = (html->getElementsByTagName("a"))[0]
      {
        date: parseSlashesMDY(entry[0]),
        appealNumber: entry[1],
        caption: a->getAttribute("sort"),
        mp3URL: a->getAttribute("href")
      }
    })
  })

