$ ->
  $("a.fileupload-exists[data-dismiss=fileupload]").click(deleteAttachment)

deleteAttachment = (event) ->
  a = $(event.target)
  form = a.parents("form")
  file = a.prev(".btn-file").find("input[type=file]")
  form.append("<input type=\"hidden\" name=\"#{file.attr("name").replace(/\[attachment\]$/, "[_destroy]")}\" value=\"1\"/>")
  a.parents(".control-group").remove()
  true
