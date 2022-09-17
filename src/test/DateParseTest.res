
module Moment = {
  type t
  
  @module external parseStringFormat: (string, string) => t = "moment"
  @send external toDate: (t, ()) => Js.Date.t = "toDate"
}

let text = "Thu, 04 Aug 2022 18:04:58 +0000"
let format = "ddd, DD MMM YYYY HH:mm:ss ZZ"

Js.Console.log(Moment.parseStringFormat(text, format)->Moment.toDate()->Js.Date.toUTCString)

