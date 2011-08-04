module.exports = (foundation, doorman) ->

  foundation.join = (workspaceInfo, hereYouGo) ->
    doorman.leadPersonToRoom @user.clientId, workspaceInfo.roomNumber
    hereYouGo()

  return foundation