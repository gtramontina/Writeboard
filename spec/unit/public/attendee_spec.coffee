ATTENDEE = '../../../lib/public/javascripts/attendee'

describe 'Attendant', ->
  
  attendee = n00p
  roomDouble = n00p
  workspaceDouble = n00p

  roomReadyCallback = n00p
  hereYouGoCallback = n00p

  beforeEach ->
    roomDouble = stubWith 'room', ['join', 'ready']
    roomDouble.join.andCallFake (workspace, callback) -> hereYouGoCallback = callback
    roomDouble.ready.andCallFake (callback) -> roomReadyCallback = callback
    workspaceDouble = stubWith 'workspace', ['setup']
    workspaceDouble.info = 'My local initial setup'
    
    attendee = require(ATTENDEE) roomDouble, workspaceDouble
  
  describe 'when at the door', ->
    it 'should request access to a room', ->
      roomReadyCallback()
      roomDouble.join.should_have_been_called_with 'My local initial setup', any Function

  describe 'after joining the room', ->
    updatedRoomSetup = boardSize: '100x100'
    it 'should have their workspace setup', ->
      roomReadyCallback()
      hereYouGoCallback(updatedRoomSetup)
      workspaceDouble.setup.should_have_been_called_with updatedRoomSetup