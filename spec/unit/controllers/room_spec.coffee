ROOM = '../../../lib/controllers/room'

describe 'Room controller', ->
  it 'should render the room view', ->
    webAppDouble  = stubWith 'webApp'  , ['get']
    fakeResponse  = stubWith 'response', ['render']
    webAppDouble.get.andCallFake (_, callback) -> callback(_, fakeResponse)
    require(ROOM) webAppDouble

    webAppDouble.get.should_have_been_called_with '/:roomId', any Function
    fakeResponse.render.should_have_been_called_with 'room'