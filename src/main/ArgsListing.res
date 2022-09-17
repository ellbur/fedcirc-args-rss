
type promise<'a> = Promise.t<'a>

module Moment = {
  type t
  
  @module external parseStringFormat: (string, string) => t = "moment"
  @send external toDate: (t, ()) => Js.Date.t = "toDate"
}

type axiosRes = {
  responseUrl: string
}

type axiosBackRequest = {
  res: axiosRes
}

type axiosResponse<'a> = {
  data: 'a,
  request: axiosBackRequest
}

@module("axios") external axiosPost: (string, string) => Promise.t<axiosResponse<'a>> = "post"
@module("axios") external axiosGet: string => Promise.t<axiosResponse<'a>> = "get"
@module("xml2js") external parseXMLString: (string, (. option<{..}>, {..}) => ()) => () = "parseString"

let listArgs = () => 
  axiosGet("https://cafc.uscourts.gov/category/oral-argument/feed/")->Promise.then(resp => {
    Promise.make((resolve, _reject) => {
      parseXMLString(resp.data, (. _err, xml) => {
        let channel = xml["rss"]["channel"][0]
        let items = channel["item"]
        resolve(. items->Belt.Array.slice(~offset=0, ~len=20)->Js.Array2.map(item => {
          Js.Console.log(item)
          {
            Model.date: Moment.parseStringFormat(
              item["pubDate"], "ddd, DD MMM YYYY HH:mm:ss ZZ")->Moment.toDate(),
            Model.title: item["title"],
            Model.mp3URL: LinkParsing.findMP3URL(item["content:encoded"])->Belt.Option.getExn,
          }
        }))
      })
    })
  })

