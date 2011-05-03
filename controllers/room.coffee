module.exports = (app, nowjs) ->

  app.get '/:roomId', (req, res) ->
    res.render 'writeboard', { title: 'Writeboard!', roomId: req.params.roomId }

  everyone = nowjs.initialize app
  everyone.now.joinRoom = (roomInfo, callback) ->
    room = getRoom roomInfo
    console.log require('sys').inspect room
    handleCanvasSize room, roomInfo.canvas
    room.addUser @user.clientId
    callback()

  getRoom = (roomInfo) ->
    room = nowjs.getGroup roomInfo.id
    return room if room.augumented

    room.now.sendStartDrawing = (x, y) -> room.now.startDrawing x, y
    room.now.sendDraw = (x, y) -> room.now.draw x, y
    room.now.sendStopDrawing = -> room.now.stopDrawing()
    room.maxCanvasSize = width: roomInfo.canvas.width, height: roomInfo.canvas.height
    room.augumented = true
    room

  handleCanvasSize = (room, newCanvasSize) ->
    room.maxCanvasSize.width = newCanvasSize.width if newCanvasSize.width > room.maxCanvasSize.width
    room.maxCanvasSize.height = newCanvasSize.height if newCanvasSize.height > room.maxCanvasSize.height

    room.now.resizeCanvas room.maxCanvasSize.width, room.maxCanvasSize.height

