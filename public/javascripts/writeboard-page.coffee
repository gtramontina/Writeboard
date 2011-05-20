writeboardPage = ->
  dom =
    body: $ 'body'
    canvas: $ '#writeboard'
    helpButton: $ '.help'
    eye: $ '.eye'
    loadingBox: $ 'div#loading-message'
    loadingMessage: $ 'div#loading-message span'
    room: $ 'room'

  loading = (message) ->
    dom.loadingMessage.text message
    show: -> dom.loadingBox.fadeIn()
    hide: -> dom.loadingBox.fadeOut()

  now.updateUserCount = (count) ->
    dom.eye.text count
    dom.eye.animate(opacity: 1).animate opacity: .3

  (loading 'Loading. Please wait...').show()
  writeboard = createWriteboard dom.canvas[0], window.innerWidth, window.innerHeight

  dom.canvas.bind 'selectstart', -> false
  dom.helpButton.click ->
    $.get '/about', { noLayout: true }, (aboutPage) ->
      about = $ "#{aboutPage}"
      about.hide()
      dom.body.append about
      about.fadeIn()

  enableCanvas = (drawings) ->
    replay writeboard, drawings

    now.startDrawing = (x, y) -> writeboard.startDrawing x, y
    now.draw = (x, y) -> writeboard.draw x, y
    now.stopDrawing = -> writeboard.stopDrawing()

    context = dom.canvas[0].getContext '2d'
    drawing = false
    lastY = 0
    dom.canvas.mousedown (event) ->
      return if drawing
      drawing = true
      now.sendStartDrawing event.pageX, event.pageY
    dom.canvas.mousemove (event) ->
      return if not drawing
      now.sendDraw event.pageX, event.pageY
    dom.canvas.mouseup ->
      drawing = false
      now.sendStopDrawing()

    loading().hide()

  replay = (writeboard, drawings) ->
    for path in drawings
      point = path.shift()
      writeboard.startDrawing point.x, point.y
      writeboard.draw point.x, point.y for point in path
      writeboard.stopDrawing

  #API
  joinRoom: ->
    (loading "Joining room... ").show()
    now.joinRoom (dom.room.attr 'id'), enableCanvas

$ ->
  page = writeboardPage()
  now.ready -> page.joinRoom()

