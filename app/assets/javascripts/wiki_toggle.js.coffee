$.fn.wiki_toggle = ->
  wikiClasses = ["vp", "dm"]

  @.on "click", (event) ->
    a = $(event.target)
    toHide = a.data()["target"]

    $.each (wikiClasses), (idx, name) ->
      if name in toHide
        $(".#{name}").hide()
      else
        $(".#{name}").show()

    event.preventDefault()
    false

  @
