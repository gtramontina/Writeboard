module.exports = (foundation, doorman) ->

  foundation.join = (workspaceInfo, hereYouGo) ->
    doorman.leadPersonToRoom @user.clientId, workspaceInfo
    hereYouGo doorman.giveMeRoomInfo workspaceInfo.roomNumber

  return foundation