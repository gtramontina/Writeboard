writeboardPage = ->
  humane.waitForMove = false

  dom =
    body: $ 'body'
    canvas: $ '#writeboard'
    helpButton: $ '.help'
    eye: $ '.eye'
    loadingBox: $ 'div#loading-message'
    loadingMessage: $ 'div#loading-message span'
    room: $ 'room'
    markers: $('#markers').children()

  loading = (message) ->
    dom.loadingMessage.text message
    show: -> dom.loadingBox.fadeIn()
    hide: -> dom.loadingBox.fadeOut()

  now.takeSnapshot = (callback) -> callback writeboard.takeSnapshot()

  peopleWatching = false
  now.updateUserCount = (count) ->
    action = if peopleWatching < count then 'joined' else 'left'
    humane "Someone #{action} the room" if peopleWatching
    dom.eye.text peopleWatching = count

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

  dom.markers.click (e) ->
    selectedMarker = ($ e.target)
    dom.markers.each (i, marker) -> if marker is e.target then $(marker).removeClass 'shut' else $(marker).addClass 'shut'
    writeboard.setColor(selectedMarker.attr 'data-color')

  closeTheDoor = (roomInfo) ->
    writeboard.resize roomInfo.size
    snapshot = roomInfo.snapshot
    if snapshot then writeboard.splash snapshot, enableCanvas else enableCanvas()

  enableCanvas = ->
    now.startDrawing = (x, y) -> writeboard.startDrawing x, y
    now.draw = (x, y) -> writeboard.draw x, y
    now.stopDrawing = -> writeboard.stopDrawing()
    now.resizeBoard = (size) ->
      humane 'And a bigger board is required'
      writeboard.resize size

    drawing = false
    dom.canvas.mousedown (event) ->
      drawing = true
      [x, y] = [event.pageX, event.pageY]
      now.startDrawing x, y
      now.sendStartDrawing x, y
    dom.canvas.mousemove (event) ->
      return if not drawing
      [x, y] = [event.pageX, event.pageY]
      now.draw x, y
      now.sendDraw x, y
    dom.canvas.mouseup ->
      drawing = false
      now.stopDrawing()
      now.sendStopDrawing()

    loading().hide()

  #API
  joinRoom: ->
    (loading "Joining room... ").show()
    roomInfo =
      id: dom.room.attr 'id'
      size: width: rawCanvas.width, height: rawCanvas.height
    now.joinRoom roomInfo, closeTheDoor

$ ->
  page = writeboardPage()
  now.ready -> page.joinRoom()

