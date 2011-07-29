module.exports = (foundation, doorman) ->

  foundation.join = ({room: room, personalInfo: personalInfo}, cb_hereYouGo) ->
    doorman.leadPersonToRoom personalInfo, room
    cb_hereYouGo()

  return foundation