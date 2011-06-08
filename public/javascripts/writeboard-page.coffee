WriteboardPage = ->
  humane.waitForMove = false
  loading.setShowAnimation (element) ->
    [element.style.opacity, element.style.display] = [0, 'initial']
    emile element, 'opacity:1'
  loading.setHideAnimation (element) ->
    emile element, 'opacity:0', after: -> element.style.display = 'none'

  peopleWatching = false

  dom =
    body          : $ 'body'
    canvas        : $ '#writeboard'
    helpButton    : $ '.help'
    eye           : $ '.eye'
    lock          : $ '.lock'
    loadingBox    : $ 'div#loading-message'
    loadingMessage: $ 'div#loading-message span'
    room          : $ 'room'
    markers       : $ '#markers'

  messages =
    loading     : 'Loading. Please wait...'
    joining     : 'Joining room...'
    joinedRoom  : 'Someone joined the room'
    leftRoom    : 'Someone left the room'
    biggerBoard : 'And a bigger board is required'
    setPassword : 'Enter a password:\n\nNOTE: there is no password encryption yet, so please do not use any of your personal passwords!'
    askPassword : 'This room is locked. Please enter the password to open it.'
    wrongPassword: 'Wrong password.'
    roomLocked  : 'The room has been locked'

  loading.show messages.loading

  rawCanvas = dom.canvas[0]
  [rawCanvas.width, rawCanvas.height] = [window.innerWidth, window.innerHeight]
  writeboard = createWriteboard rawCanvas

  now.takeSnapshot = (callback) ->
    callback writeboard.takeSnapshot()

  now.updateUserCount = (count) ->
    humane messages[if peopleWatching < count then 'joinedRoom' else 'leftRoom'] if peopleWatching
    dom.eye.text peopleWatching = count

  now.requirePassword = (callback, wrong) ->
    alert messages.wrongPassword if wrong
    password = prompt messages.askPassword
    if password then callback password else window.location.replace '/'

  now.setColor = (color) ->
    dom.markers.children().removeClass 'selected'
    marker = dom.markers.find "[data-color=#{color}]"
    marker.addClass 'selected'
    writeboard.setColor color

  dom.canvas.bind 'selectstart', -> false
  dom.helpButton.click ->
    $.get '/about', { noLayout: true }, (aboutPage) ->
      about = $ "#{aboutPage}"
      about.hide()
      dom.body.append about
      about.fadeIn()

  dom.lock.click ->
    password = prompt messages.setPassword
    now.sendLockRoom password if password


  closeTheDoor = (roomInfo) ->
    writeboard.resize roomInfo.size
    now.setColor roomInfo.markerColor
    snapshot = roomInfo.snapshot
    if snapshot then writeboard.splash snapshot, enableCanvas else enableCanvas()

  enableCanvas = ->
    now.startDrawing = (x, y) ->
      writeboard.startDrawing x, y
    now.draw = (x, y) ->
      writeboard.draw x, y
    now.stopDrawing = ->
      writeboard.stopDrawing()
    now.resizeBoard = (size) ->
      humane messages.biggerBoard
      writeboard.resize size
    now.setRoomLocked = ->
      humane messages.roomLocked
      dom.lock.removeClass 'lock'
      dom.lock.addClass 'unlock'

    dom.markers.click (e) ->
      color = $(e.target).attr 'data-color'
      now.setColor color
      now.sendSetColor color

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

    loading.hide()

  # Page API
  joinRoom: ->
    loading.show messages.joining
    roomInfo =
      id          : dom.room.attr 'id'
      markerColor : writeboard.getColor()
      size        : width: rawCanvas.width, height: rawCanvas.height
    now.joinRoom roomInfo, closeTheDoor

$ ->
  page = WriteboardPage()
  now.ready -> page.joinRoom()

