
let axiosGet = Axios.get
@module("xml2js") external parseXMLString: (string, (. option<{..}>, {..}) => ()) => () = "parseString"

type promise<'a> = Promise.t<'a>

module Moment = {
  type t
  
  @module("moment") external parseStringFormat: (string, string) => t = "default"
  @send external toDate: (t, ()) => Js.Date.t = "toDate"
}

let listArgs = () => 
  axiosGet("http://cafc.uscourts.gov/category/oral-argument/feed/", {})->Promise.then(resp => {
    Promise.make((resolve, _reject) => {
      parseXMLString(resp.data, (. _err, xml) => {
        let channel = xml["rss"]["channel"][0]->Option.getExn
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

