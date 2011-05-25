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

  now.takeSnapshot = (callback) -> callback writeboard.takeSnapshot()
  now.updateUserCount = (count) ->
    dom.eye.text count
    dom.eye.animate(opacity: 1).animate opacity: .3

  (loading 'Loading. Please wait...').show()
  rawCanvas = dom.canvas[0]
  [rawCanvas.width, rawCanvas.height] = [window.innerWidth, window.innerHeight]
  writeboard = createWriteboard rawCanvas

  dom.canvas.bind 'selectstart', -> false
  dom.helpButton.click ->
    $.get '/about', { noLayout: true }, (aboutPage) ->
      about = $ "#{aboutPage}"
      about.hide()
      dom.body.append about
      about.fadeIn()

  enableCanvas = (drawings) ->
    writeboard.splash drawings if drawings?

    now.startDrawing = (x, y) -> writeboard.startDrawing x, y
    now.draw = (x, y) -> writeboard.draw x, y
    now.stopDrawing = -> writeboard.stopDrawing()

    drawing = false
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

  #API
  joinRoom: ->
    (loading "Joining room... ").show()
    roomInfo =
      id: dom.room.attr 'id'
      size: width: rawCanvas.width, height: rawCanvas.height
    now.joinRoom roomInfo, enableCanvas

$ ->
  page = writeboardPage()
  now.ready -> page.joinRoom()

