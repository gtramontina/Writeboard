INDEX = '../../../lib/controllers'

describe 'Index controller', ->
  it 'should redirect to a new room', ->
    webAppDouble  = stubWith 'webApp'  , ['get']
    fakeResponse  = stubWith 'response', ['redirect', 'render']
    fakeRequest   = params: roomId: 'a timestamp value'
    webAppDouble.get.andCallFake (_, callback) -> callback(fakeRequest, fakeResponse)
    require(INDEX) webAppDouble

    webAppDouble.get.should_have_been_called_with '/', any Function
    fakeResponse.redirect.should_have_been_called_with match /^\/\d{13}$/