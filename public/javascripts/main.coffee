#http://code.jquery.com/jquery-1.5.2.min.js
$ ->
  canvas = document.getElementById 'writeboard'
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
  context = canvas.getContext '2d'
  canvas = $ canvas
  writeboard = createWriteboard context

  drawing = false
  canvas.mouseup ->
    drawing = false
    writeboard.stopDrawing()
  canvas.mousedown (event) ->
    drawing = true
    x = event.clientX - @offsetLeft
    y = event.clientY - @offsetTop
    writeboard.startDrawing x, y
  canvas.mousemove (event) ->
    return if not drawing
    x = event.clientX - @offsetLeft
    y = event.clientY - @offsetTop
    now.addPoint x, y

  now.draw = (x, y) ->
    writeboard.draw x, y

