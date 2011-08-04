module.exports = (foundation) ->
  leadPersonToRoom: (person, roomNumber) ->
    room = foundation.getGroup roomNumber
    room.addUser person