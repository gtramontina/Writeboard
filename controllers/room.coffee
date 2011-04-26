module.exports = (app, nowjs) ->

  app.get '/:roomId', (req, res) ->
    roomId = req.params.roomId
    room = nowjs.getGroup roomId

    room.now.sendStartDrawing = (x, y) -> room.now.startDrawing x, y
    room.now.sendDraw = (x, y) -> room.now.draw x, y
    room.now.sendStopDrawing = -> room.now.stopDrawing()

    res.render 'writeboard', { title: 'Writeboard!', roomId: roomId }

