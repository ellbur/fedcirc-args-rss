
type axiosRes = {
  responseUrl: string
}
type axiosRequest = {
  res: axiosRes
}
type axiosResponse<'t> = {
  data: 't,
  request: axiosRequest
}

type opts<'a> = {
  headers?: 'a,
  agent?: NodeJs.Https.Agent.t
}

module Axios = {
  module Default = {
    type t = {
      "get": 't 'a. (string, opts<'a>) => promise<axiosResponse<'t>>,
      "post": 't 'a. (string, string, opts<'a>) => promise<axiosResponse<'t>>
    }
  }
  
  type t = {
    "default": Default.t
  }
}

@module external axios: Axios.t = "axios"

let get: 't 'a. (string, opts<'a>) => promise<axiosResponse<'t>> = (url, opts) => axios["default"]["get"](url, opts)

let post: 't 'a. (string, string, opts<'a>) => promise<axiosResponse<'t>> = (url, payload, opts) => axios["default"]["post"](url, payload, opts)

