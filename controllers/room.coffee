module.exports = (app, nowjs) ->

  app.get '/:roomId', (req, res) ->
    res.render 'writeboard', { title: 'Writeboard!', roomId: req.params.roomId }

  everyone = nowjs.initialize app
  everyone.now.joinRoom = (roomInfo, callback) ->
    room = getRoom roomInfo

    clientId = @user.clientId
    ready = (callback, snapshot) ->
      room.addUser clientId
      checkRoomSize room, roomInfo.size
      callback snapshot: snapshot, size: room.size

    return ready callback if room.count is 0

    gotSnapshot = false
    room.now.takeSnapshot (snapshot) ->
      if not gotSnapshot
        gotSnapshot = true
        ready callback, snapshot

  checkRoomSize = (room, size) ->
    dirty = false
    (room.size.width = size.width) and dirty = true if size.width > room.size.width
    (room.size.height = size.height) and dirty = true if size.height > room.size.height
    room.now.resizeBoard room.size if dirty

  getRoom = (roomInfo) ->
    room = nowjs.getGroup roomInfo.id
    return room if room.augumented

    updateUserCount = -> room.now.updateUserCount room.count
    room.on 'connect', updateUserCount
    room.on 'disconnect', updateUserCount

    room.now.filter = (sourceClient, func, x, y) -> @now[func] x, y if sourceClient isnt @user.clientId

    room.now.sendStartDrawing = (x, y) -> room.now.filter @user.clientId, 'startDrawing', x, y
    room.now.sendDraw = (x, y) -> room.now.filter @user.clientId, 'draw', x, y
    room.now.sendStopDrawing = -> room.now.filter @user.clientId, 'stopDrawing'
    room.size = roomInfo.size
    room.augumented = true
    room

