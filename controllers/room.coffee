module.exports = (app, nowjs) ->

  app.get '/:roomId', (req, res) ->
    res.render 'writeboard', { title: 'Writeboard!', roomId: req.params.roomId }

  everyone = nowjs.initialize app
  everyone.now.joinRoom = (roomInfo, callback) ->
    room = getRoom roomInfo
    room.addUser @user.clientId
    callback(room.drawings)

  getRoom = (roomInfo) ->
    room = nowjs.getGroup roomInfo.id
    return room if room.augumented

    room.drawings = []
    room.now.sendStartDrawing = (x, y) ->
      room.currentDrawing = [ x: x, y: y ]
      room.now.startDrawing x, y
    room.now.sendDraw = (x, y) ->
      room.currentDrawing.push x: x, y: y
      room.now.draw x, y
    room.now.sendStopDrawing = ->
      room.drawings.push room.currentDrawing
      room.now.stopDrawing()
    room.augumented = true
    room

