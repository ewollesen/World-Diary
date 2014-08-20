$.fn.rollDice = ->
  @.on "click", (event) ->
    span = $(event.target)
    sides = parseInt(span.data("sides"))
    rolls = parseInt(span.data("rolls")) ? 1
    mod = parseInt(span.data("mod")) ? 0
    results = dxx(sides, rolls, mod)
    # TODO throw a modal instead?
    alert("Rollin' 'dem bones!' " + span.text() + ":\nRolls: " + results[0] + "\nTotal: " + results[1])

    event.preventDefault()
    false

  @

window.dxx = (sides, rolls=1, mod=0) ->
  allRolls = (1 + wd.rand(20) for x in [1..rolls])
  sum = allRolls.reduce (sum, roll) ->
    sum + roll
  , mod
  [allRolls, sum]

ready = ->
  $("span[data-sides]").rollDice()

$(document).ready(ready)
$(document).on("page:load", ready)
