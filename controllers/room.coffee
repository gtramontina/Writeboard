Canvas = require 'canvas'
module.exports = (app, nowjs, writeboard) ->

  app.get '/:roomId', (req, res) ->
    res.render 'writeboard', { title: 'Writeboard!', roomId: req.params.roomId }

  everyone = nowjs.initialize app
  everyone.now.joinRoom = (roomInfo, callback) ->
    room = getRoom roomInfo
    room.addUser @user.clientId
    callback room.writeboard.getData()

  getRoom = (roomInfo) ->
    room = nowjs.getGroup roomInfo.id
    return room if room.augumented

    updateUserCount = -> room.now.updateUserCount room.count
    room.on 'connect', updateUserCount
    room.on 'disconnect', updateUserCount

    canvas = new Canvas roomInfo.size.width, roomInfo.size.height
    room.writeboard = writeboard.createWriteboard canvas
    room.now.sendStartDrawing = (x, y) ->
      setTimeout (-> room.writeboard.startDrawing x, y), 1
      room.now.startDrawing x, y
    room.now.sendDraw = (x, y) ->
      setTimeout (-> room.writeboard.draw x, y), 1
      room.now.draw x, y
    room.now.sendStopDrawing = ->
      setTimeout room.writeboard.stopDrawing, 1
      room.now.stopDrawing()
    room.augumented = true
    room

