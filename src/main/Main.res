
let doRSS = () => ArgsListing.listArgs()->Promise.thenResolve(RSSGeneration.generateRSS)

