$ ->
  canvas = document.getElementById 'writeboard'
  [canvas.width, canvas.height] = [window.innerWidth, window.innerHeight]
  bindButtons()

now.ready -> joinRoom $('room').attr 'id'

joinRoom = (roomId) ->
  now.joinRoom id: roomId,
    enableCanvas

enableCanvas = ->
  $canvas = $ '#writeboard'
  writeboard = createWriteboard $canvas[0].getContext '2d'

  drawing = false
  $canvas.mouseup ->
    drawing = false
    now.sendStopDrawing()
  $canvas.mousedown (event) ->
    drawing = true
    x = event.clientX - @offsetLeft
    y = event.clientY - @offsetTop
    now.sendStartDrawing x, y
  $canvas.mousemove (event) ->
    return if not drawing
    x = event.clientX - @offsetLeft
    y = event.clientY - @offsetTop
    now.sendDraw x, y

  now.startDrawing = (x, y) -> writeboard.startDrawing x, y
  now.draw = (x, y) -> writeboard.draw x, y
  now.stopDrawing = -> writeboard.stopDrawing()

bindButtons = ->
  $('.help').click ->
    $.get '/about', { noLayout: true }, (aboutPage) ->
      $about = $ "#{aboutPage}"
      $about.hide()
      $('body').append $about
      $about.fadeIn()

