now.ready ->
  buildCanvas()
  bindButtons()

buildCanvas = ->
  roomId = $('room').get(0).id
  canvas = now.resizeCanvas()
  joinRoom roomId, canvas

now.resizeCanvas = (width = window.innerWidth, height = window.innerHeight) ->
  canvas = document.getElementById 'writeboard'
  canvas.width = width
  canvas.height = height
  canvas

joinRoom = (roomId, canvas) ->
  now.joinRoom
    id: roomId,
    canvas: width: canvas.width, height: canvas.height,
    -> enableCanvas canvas

enableCanvas = (canvas) ->
  context = canvas.getContext '2d'
  writeboard = createWriteboard context

  $canvas = $ canvas
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

