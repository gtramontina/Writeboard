module.exports = (app, nowjs) ->

  app.get '/:roomId', (req, res) ->
    res.render 'writeboard', { title: 'Writeboard!', roomId: req.params.roomId }

  everyone = nowjs.initialize app
  everyone.now.joinRoom = (roomInfo, callback) ->
    room = getRoom roomInfo
    room.addUser @user.clientId

    if room.count > 1
      gotSnapshot = false
      room.now.takeSnapshot (snapshot) -> (gotSnapshot = true) && callback snapshot if not gotSnapshot
    else callback()

  getRoom = (roomInfo) ->
    room = nowjs.getGroup roomInfo.id
    return room if room.augumented

    updateUserCount = -> room.now.updateUserCount room.count
    room.on 'connect', updateUserCount
    room.on 'disconnect', updateUserCount

    room.now.sendStartDrawing = (x, y) -> room.now.startDrawing x, y
    room.now.sendDraw = (x, y) -> room.now.draw x, y
    room.now.sendStopDrawing = -> room.now.stopDrawing()
    room.augumented = true
    room

