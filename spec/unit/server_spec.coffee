SERVER = '../../lib/server'
describe 'Writeboard Server', ->

  webAppDouble  = n00p
  expressDouble = n00p
  stylusDouble  = n00p
  app           = n00p

  beforeEach ->
    webAppDouble  = stubWith 'webApp' , ['listen', 'set']
    expressDouble = stubWith 'express', ['createServer', 'compiler', 'static']
    stylusDouble  = stubWith 'stylus' , ['middleware']
    expressDouble.createServer.andCallFake -> webAppDouble
    stylusDouble.middleware.andCallFake -> 'stylus middleware'
    expressDouble.compiler.andCallFake -> 'express compiler'
    expressDouble.static.andCallFake -> 'express static'

    app = require(SERVER) expressDouble, stylusDouble

  # Test Suite =================================================================

  it 'should export an express server', ->
    expect(app).toEqual webAppDouble

  it 'should listen on a port', ->
    webAppDouble.listen.should_have_been_called_with 9796

  it 'should set a views directory', ->
      webAppDouble.set.should_have_been_called_with 'views', any String
      webAppDouble.set.mostRecentCall.args[1].should_match /\/views$/

  describe 'when being configured (the order matters)', ->

    it 'should use the stylus middleware', ->
      expressDouble.createServer.mostRecentCall.args[0].should_be 'stylus middleware'
      expect(stylusDouble.middleware.mostRecentCall.args[0]).to_have_attributes src: /\/public$/, compile: any Function

    it 'should use the express compiler middleware to enable coffeescript', ->
      expressDouble.createServer.mostRecentCall.args[1].should_be 'express compiler'
      expect(expressDouble.compiler.mostRecentCall.args[0]).to_have_attributes src: /\/public$/, enable: ['coffeescript']

    it 'should use the express static middleware to serve static content', ->
      expressDouble.createServer.mostRecentCall.args[2].should_be 'express static'
      expect(expressDouble.static.mostRecentCall.args[0]).to_have_attributes src: /\/public$/