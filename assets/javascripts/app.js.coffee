class @Links
  constructor: (list) ->
    @path = list + "/urls"

  load: ->
    $.getJSON @path, (data) =>
      $.each data, (index, url) =>
        @renderLink url

  renderLink: (url) ->
    source   = $("#link-template").html()
    template = Handlebars.compile(source)
    context = { url: url }
    html = template context
    $(".urls").append html

  add: (url) ->
    $.ajax
      type: "POST"
      url: @path
      data:
        url: url
      success: (data) =>
        @renderLink JSON.parse(data).url
        @clearInput()

  clearInput: ->
    $(".new-url input[type=text]").val("")

  delete: (url) ->
    $.ajax
      type: "DELETE"
      url: @path
      data:
        url: url
      success: ->
        $(".urls").find("li[data-url='" + url + "']").remove()

$(document).on "keypress", ".new-url input[type=text]", (event) ->
  if event.keyCode is 13
    App.links.add $(event.currentTarget).val()

$(document).on "click", ".new-url button", ->
  App.links.add $(this).prev().val()

$(document).on "click", ".url button", ->
  App.links.delete $(this).data('url')
