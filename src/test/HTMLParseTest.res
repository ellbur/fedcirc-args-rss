
module HtmlCollection = {
  type t
}

module HtmlElement = {
  type t
}

@module("node-html-parser") external parseHTML: string => HtmlElement.t = "parse"

let html =
`<p>Oral argument audio posted: </p>
<p><a href="https://oralarguments.cafc.uscourts.gov/default.aspx?fl=21-2208_08042022.mp3">Philanthropist.com, Inc. v. General Conference Corp. of Seventh-Day Ad (mp3)</a> <br />Appeal Number: 2021-2208 </p>
<p>To listen to more oral argument recordings, follow this link: <a href ="/home/oral-argument/listen-to-oral-arguments/">Listen To Oral Arguments</a>.</p>`

let parsed = parseHTML(html)
Js.Console.log(parsed)

