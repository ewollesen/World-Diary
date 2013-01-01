jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $("abbr[rel=tooltip]").tooltip()
  $("h1 abbr[rel=tooltip]").tooltip("destroy").tooltip({placement: "bottom"})
