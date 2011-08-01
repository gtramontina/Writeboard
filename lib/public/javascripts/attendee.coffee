module.exports = (room, workspace) ->
  hereIGo = (roomSetup) -> workspace.setup roomSetup
  join = -> room.join workspace.info, hereIGo
  
  room.ready join