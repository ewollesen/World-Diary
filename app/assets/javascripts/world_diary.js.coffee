ready = ->
  $("a[rel=wiki_toggle]").wiki_toggle()

$(document).ready(ready)
$(document).on("page:load", ready)
