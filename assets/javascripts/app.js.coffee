@Links =
  getLinks: (list) ->
    $.getJSON list + "/urls", (data) =>
      $.each data, (index, url) =>
        @renderLink url

  renderLink: (url) ->
    source   = $("#link-template").html()
    template = Handlebars.compile(source)
    context = { url: url }
    html = template context
    $(".urls").append html

  deleteLink: (url) ->
    # delete from server

    #delete from page

$(document).on "click", "[data-behavior~=delete-link]", ->
  Links.deleteLink $(this).data('url')