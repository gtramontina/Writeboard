vows = require 'vows'
require 'should'

vows.describe('Server').addBatch({
  'When being configured':
    topic: require '../server'

    'should have Jade as the view engine': (server) ->
      server.settings.should.have.property 'view engine', 'jade'

}).export module

