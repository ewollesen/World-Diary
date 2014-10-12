leaders = [
  "alche",
  "asche",
  "bos",
  "canter",
  "carls",
  "dodin",
  "east",
  "eden",
  "hac",
  "helm",
  "here",
  "ips",
  "lon",
  "new",
  "nor",
  "north",
  "ox",
  "piche",
  "rox",
  "salis",
  "south",
  "thet",
  "tre",
  "west",
  "yor",
  ]

trailers = [
  "borough",
  "bridge",
  "bury",
  "by",
  "castle",
  "ester",
  "ford",
  "ingham",
  "pool",
  "ton",
  "tone",
  "tun",
  "ville",
  "wich",
  ]

middles = [
  "bon",
  "man",
  "hamp",
  ]

prefixes = [
  "new",
  "little",
  "old",
  ]

suffixes = [
  "arbor",
  "ferry",
  "grove",
  "of the hill",
  ]

rand = (max) ->
  Math.floor(Math.random() * max)

generate = ->
  leader = leaders[rand(leaders.length)]
  trailer = trailers[rand(trailers.length)]
  mids = []
  while Math.random() > 0.8
    mids.push(middles[rand(middles.length)])
  if Math.random() > 0.95
    prefix = " " + prefixes[rand(prefixes.length)]
  else
    prefix = ""
  if Math.random() > 0.9
    suffix = " " + suffixes[rand(suffixes.length)]
  else
    suffix = ""
  middle = ""
  mids.forEach (mid) -> middle = middle + mid

  leader + middle + trailer + suffix

window.cityName = ->
  generate()

window.rand = rand
