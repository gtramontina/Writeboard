writeboardPage = ->
  dom =
    body: $ 'body'
    canvas: $ '#writeboard'
    helpButton: $ '.help'
    loadingBox: $ 'div#loading-message'
    loadingMessage: $ 'div#loading-message span'
    room: $ 'room'

  loading = (message) ->
    dom.loadingMessage.text message
    show: -> dom.loadingBox.fadeIn()
    hide: -> dom.loadingBox.fadeOut()

  (loading 'Loading. Please wait...').show()
  [dom.canvas[0].width, dom.canvas[0].height] = [window.innerWidth, window.innerHeight]

  dom.helpButton.click ->
    $.get '/about', { noLayout: true }, (aboutPage) ->
      about = $ "#{aboutPage}"
      about.hide()
      dom.body.append about
      about.fadeIn()

  enableCanvas = (drawings) ->
    writeboard = createWriteboard dom.canvas[0].getContext '2d'
    replay writeboard, drawings

    now.startDrawing = (x, y) -> writeboard.startDrawing x, y
    now.draw = (x, y) -> writeboard.draw x, y
    now.stopDrawing = -> writeboard.stopDrawing()

    drawing = false
    dom.canvas.mouseup ->
      drawing = false
      now.sendStopDrawing()
    dom.canvas.mousedown (event) ->
      drawing = true
      x = event.clientX - @offsetLeft
      y = event.clientY - @offsetTop
      now.sendStartDrawing x, y
    dom.canvas.mousemove (event) ->
      return if not drawing
      x = event.clientX - @offsetLeft
      y = event.clientY - @offsetTop
      now.sendDraw x, y

    loading().hide()

  replay = (writeboard, drawings) ->
    for path in drawings
      point = path.shift()
      writeboard.startDrawing point.x, point.y
      writeboard.draw point.x, point.y for point in path
      writeboard.stopDrawing

  #API
  joinRoom: ->
    (loading 'Joining room...').show()
    now.joinRoom (dom.room.attr 'id'), enableCanvas


$ ->
  page = writeboardPage()
  now.ready -> page.joinRoom()

