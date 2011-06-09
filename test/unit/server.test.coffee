vows = require 'vows'
require 'should'


expressMock = (->
  createServerCalled = false
  createServer: ->
    createServerCalled = true,
  createServerCalled: -> createServerCalled
)()

vows.describe('Server').addBatch({
  'Being set up':
    topic: require('../server')(expressMock, null)

    'should create an express server': ->
      expressMock.createServerCalled().should.be.true

    'should have Jade as the view engine': (server) ->
      server.settings.should.have.property 'view engine', 'jade'

}).export module

