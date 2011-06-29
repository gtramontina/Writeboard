WRITEBOARD_SERVER = '../../lib/server'

describe 'The Writeboard server', ->
  beforeEach ->
    @webAppMock = stubObj 'webAppMock', ['configure', 'listen']
    @expressMock = createServer: noop
    spyOn(@expressMock, 'createServer').andReturn @webAppMock

  it 'should create an Express web application', ->
    require(WRITEBOARD_SERVER) @expressMock
    @expressMock.createServer.should_have_been_called()

  it 'should be configured', ->
    require(WRITEBOARD_SERVER) @expressMock
    @webAppMock.configure.should_have_been_called_with any Function

  it 'should listen on port 9796', ->
    require(WRITEBOARD_SERVER) @expressMock
    @webAppMock.listen.should_have_been_called_with 9796

  it 'should initialize the controllers', ->
    controllerOne = stub 'controllerOne'
    controllerTwo = stub 'controllerTwo'
    nowJsStub = stub 'nowJs'

    require(WRITEBOARD_SERVER) @expressMock, (stub 'stylus'), (stub 'nib'), nowJsStub,
      controllerOne, controllerTwo
    controllerOne.should_have_been_called_with @webAppMock, nowJsStub
    controllerTwo.should_have_been_called_with @webAppMock, nowJsStub

