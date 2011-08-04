DOORMAN = '../../lib/doorman'
describe 'Doorman', ->
  
  foundationDouble = n00p
  roomDouble = n00p
  doorman = n00p

  beforeEach ->
    foundationDouble  = stubWith 'foundation', ['getGroup']
    roomDouble = stubWith 'room', ['addUser']
    foundationDouble.getGroup.andCallFake -> roomDouble
    doorman = require(DOORMAN) foundationDouble
  
  it 'should lead a person to a room', ->
    doorman.leadPersonToRoom '00-12', '13'
    foundationDouble.getGroup.should_have_been_called_with '13'
    roomDouble.addUser.should_have_been_called_with '00-12'