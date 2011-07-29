ROOM = '../../../lib/controllers/room'

describe 'Room controller', ->

  it 'should render the room view', ->
    webAppDouble  = stubWith 'webApp'  , ['get']
    fakeResponse  = stubWith 'response', ['render']
    fakeRequest   = params: roomNumber: 'a timestamp value'
    webAppDouble.get.andCallFake (_, callback) -> callback(fakeRequest, fakeResponse)
    require(ROOM) webAppDouble

    webAppDouble.get.should_have_been_called_with '/:roomNumber', any Function
    fakeResponse.render.should_have_been_called_with 'room', roomNumber: 'a timestamp value'