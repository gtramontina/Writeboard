INDEX = '../../../lib/controllers'

describe 'Index controller', ->
  it 'should redirect to a new room', ->
    webAppDouble  = stubWith 'webApp'  , ['get']
    fakeResponse  = stubWith 'response', ['redirect']
    webAppDouble.get.andCallFake (_, callback) -> callback(_, fakeResponse)
    require(INDEX) webAppDouble

    webAppDouble.get.should_have_been_called_with '/', any Function
    fakeResponse.redirect.mostRecentCall.args[0].should_match /^\/\d{13}$/
