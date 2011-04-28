#http://code.jquery.com/jquery-1.5.2.min.js
now.ready ->
  now.joinRoom $('room')[0].id, ->
    canvas = document.getElementById 'writeboard'
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight

    context = canvas.getContext '2d'
    canvas = $ canvas
    writeboard = createWriteboard context

    drawing = false
    canvas.mouseup ->
      drawing = false
      now.sendStopDrawing()
    canvas.mousedown (event) ->
      drawing = true
      x = event.clientX - @offsetLeft
      y = event.clientY - @offsetTop
      now.sendStartDrawing x, y
    canvas.mousemove (event) ->
      return if not drawing
      x = event.clientX - @offsetLeft
      y = event.clientY - @offsetTop
      now.sendDraw x, y

    now.startDrawing = (x, y) -> writeboard.startDrawing x, y
    now.draw = (x, y) -> writeboard.draw x, y
    now.stopDrawing = -> writeboard.stopDrawing()

