
let listArgs = ArgsListing.listArgs
let generateRSS = RSSGeneration.generateRSS
let log = Js.Console.log
let thenResolve = Promise.thenResolve

type request = {
  "path": string,
  "url": string
}
type response
type httpFunction = (request, response) => ()
@module("@google-cloud/functions-framework") external http: (string, httpFunction) => () = "http"
@send external send: (response, string) => () = "send"
@send external set: (response, string, string) => () = "set"
@send external status: (response, int) => () = "status"

let fedcircArgsRSS = async (_req, res) => {
  try {
    let rss = await Main.doRSS()
    res->set("Content-Type", "application/rss+xml")
    res->send(rss)
  }
  catch {
    | Exn.Error(e) => {
      log(e)
      res->status(501)
      res->send("")
    }
  }
}

http("fedcircArgsRSS", (req, res) => { fedcircArgsRSS(req, res)->Promise.done })

