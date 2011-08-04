describe 'Doorman', ->
  it 'should lead a person to a room', ->
    DOORMAN = '../../lib/doorman'
    foundationDouble  = stubWith 'foundation', ['getGroup']
    roomDouble = stubWith 'room', ['addUser']
    foundationDouble.getGroup.andCallFake -> roomDouble
    doorman = require(DOORMAN) foundationDouble

    doorman.leadPersonToRoom '00-12', '13'
    foundationDouble.getGroup.should_have_been_called_with '13'
    roomDouble.addUser.should_have_been_called_with '00-12'
