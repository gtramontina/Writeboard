WORKSPACE = '../../../lib/public/javascripts/workspace.coffee'

specs = (domUtility) ->
  describe 'Workspace', ->
    it 'should initialize its information based on the DOM', ->
      workspace = require(WORKSPACE).Workspace domUtility
      workspace.info().roomNumber.should_be '13'

# DOM Mock Setup ---------------------------------------------------------------
DOLLARDOM = './lib/public/javascripts/libs/$dom.min.js'
fileSystem = require 'fs'
jsDom = require 'jsdom'
domUtilitySource = fileSystem.readFileSync(DOLLARDOM).toString()

jsDom.env
  html: '<room id="13"/>'
  src: domUtilitySource
  done: (error, window) -> specs window.$dom