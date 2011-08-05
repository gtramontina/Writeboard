module.exports = (foundation) ->
  
  leadPersonToRoom = (person, workspaceInfo) ->
    room = foundation.getGroup workspaceInfo.roomNumber
    room.addUser person
  
  giveMeRoomInfo = (roomNumber) ->
    foundation.getGroup(roomNumber).info

  # API
  leadPersonToRoom  : leadPersonToRoom
  giveMeRoomInfo    : giveMeRoomInfo