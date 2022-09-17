
let args = ArgsListing.listArgs()

args->Promise.thenResolve(args =>
  Js.Console.log(args))->ignore
  
