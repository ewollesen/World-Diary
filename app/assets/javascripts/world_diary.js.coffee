ready = ->
  $("a[rel=wiki_toggle]").wiki_toggle()

window.wd =
  rand: (max) ->
    Math.floor(Math.random() * max)

$(document).ready(ready)
$(document).on("page:load", ready)
