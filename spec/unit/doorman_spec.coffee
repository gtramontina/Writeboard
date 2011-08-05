DOORMAN = '../../lib/doorman'
describe 'Doorman', ->
  
  foundationDouble = n00p
  roomDouble = n00p
  fakeWorkspaceInfo = _
  doorman = n00p

  beforeEach ->
    foundationDouble  = stubWith 'foundation', ['getGroup']
    roomDouble = stubWith 'room', ['addUser']
    roomDouble.info = 'fake info data'
    foundationDouble.getGroup.andCallFake -> roomDouble
    fakeWorkspaceInfo = roomNumber: 'fake room number'
    doorman = require(DOORMAN) foundationDouble
  
  it 'should lead a person to a room', ->
    doorman.leadPersonToRoom 'fake person id', fakeWorkspaceInfo
    foundationDouble.getGroup.should_have_been_called_with 'fake room number'
    roomDouble.addUser.should_have_been_called_with 'fake person id'

  it 'should provide current information about a room', ->
    info = doorman.giveMeRoomInfo 'fake room number'
    info.should_be 'fake info data'
  
  describe 'when leading a person to a room', ->
    beforeEach -> doorman.leadPersonToRoom 'fake person id', fakeWorspaceInfo
    