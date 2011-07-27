module.exports = (app, nowjs) ->

  app.get '/:roomId', (req, res) ->
    res.render 'writeboard', { title: 'Writeboard!', roomId: req.params.roomId }

  everyone = nowjs.initialize app, socketio: 'log level': 2

  everyone.now.joinRoom = (roomInfo, callback) ->
    room = getRoom roomInfo

    validatePassword = (password) ->
      if password is room.password then goAhead callback else @now.requirePassword validatePassword, 'wrong'

    clientId = @user.clientId
    ready = (callback, snapshot) ->
      room.addUser clientId
      checkRoomSize room, roomInfo.size
      callback
        snapshot    : snapshot
        markerColor : room.markerColor
        size        : room.size

    goAhead = (callback) ->
      room.count (numberOfPeople) ->
        return ready callback if numberOfPeople is 0

        gotSnapshot = false
        room.now.takeSnapshot (snapshot) ->
            (gotSnapshot = true) and ready callback, snapshot if not gotSnapshot

    if room.password? then @now.requirePassword validatePassword else goAhead callback

  checkRoomSize = (room, size) ->
    dirty = false
    (room.size.width = size.width) and dirty = true if size.width > room.size.width
    (room.size.height = size.height) and dirty = true if size.height > room.size.height
    room.now.resizeBoard room.size if dirty

  getRoom = (roomInfo) ->
    room = nowjs.getGroup roomInfo.id
    return room if room.augumented

    updateUserCount = -> room.count (numberOfPeople) -> room.now.updateUserCount numberOfPeople
    room.on 'join', updateUserCount
    room.on 'connect', updateUserCount
    room.on 'disconnect', updateUserCount
    room.on 'leave', updateUserCount

    room.now.filter = (sourceClient, func, params...) -> @now[func] params... if sourceClient isnt @user.clientId
    room.now.sendStartDrawing = (x, y) -> room.now.filter @user.clientId, 'startDrawing', x, y
    room.now.sendDraw = (x, y) -> room.now.filter @user.clientId, 'draw', x, y
    room.now.sendStopDrawing = -> room.now.filter @user.clientId, 'stopDrawing'
    room.now.sendSetColor = (color) -> (room.markerColor = color) and room.now.filter @user.clientId, 'setColor', color
    room.now.sendLockRoom = (password) -> (room.password = password) and room.now.setRoomLocked()

    room.size = roomInfo.size
    room.markerColor = roomInfo.markerColor
    room.augumented = true
    room

