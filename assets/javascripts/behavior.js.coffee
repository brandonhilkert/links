$(".url").click ->
  $(this).find(".actions").toggle();

$(".url .actions button").click (event) ->
  event.stopPropagation()
  $(this).parent().toggle()
