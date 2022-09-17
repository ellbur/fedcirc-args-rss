
open Model

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

let listArgs = () => Js.Exn.raiseError("Not Implemented")

