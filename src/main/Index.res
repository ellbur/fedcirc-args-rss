
let listArgs = ArgsListing.listArgs
let generateRSS = RSSGeneration.generateRSS
let log = Js.Console.log
let then = Promise.then
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

http("fedcircArgsRSS", (_req, res) => {
  Main.doRSS()->thenResolve(rss => {
    res->set("Content-Type", "application/rss+xml")
    res->send(rss)
  })->Promise.catch(e => {
    log(e)
    res->status(500)
    res->send("")
    Promise.resolve()
  })->ignore
})

