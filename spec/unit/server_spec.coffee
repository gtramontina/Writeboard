server = '../../lib/server'
describe 'Writeboard Server', ->

	webAppDouble  = n00p
	expressDouble = n00p

	beforeEach ->
		webAppDouble  = stubWith 'webApp',  ['listen']
		expressDouble = stubWith 'express', ['createServer']
		expressDouble.createServer.andCallFake -> webAppDouble
		
	it 'should export an express server', ->
		app = require(server) expressDouble
		expressDouble.createServer.should_have_been_called()
		expect(app).toEqual webAppDouble

	it 'should listen on a port', ->
		require(server) expressDouble
		webAppDouble.listen.should_have_been_called_with 9796