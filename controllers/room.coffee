module.exports = (app, nowjs) ->

  app.get '/:roomId', (req, res) ->
    res.render 'writeboard', { title: 'Writeboard!', roomId: req.params.roomId }

  everyone = nowjs.initialize app
  everyone.now.joinRoom = (roomInfo, callback) ->
    room = getRoom roomInfo
    room.addUser @user.clientId
    callback()

  getRoom = (roomInfo) ->
    room = nowjs.getGroup roomInfo.id
    return room if room.augumented

    room.now.sendStartDrawing = (x, y) -> room.now.startDrawing x, y
    room.now.sendDraw = (x, y) -> room.now.draw x, y
    room.now.sendStopDrawing = -> room.now.stopDrawing()
    #room.maxCanvasSize = width: roomInfo.canvas.width, height: roomInfo.canvas.height
    room.augumented = true
    room

