WORKSPACE = '../../../lib/public/javascripts/workspace.coffee'

specs = (window) ->
  describe 'Workspace', ->
    workspace = n00p
    beforeEach -> workspace = require(WORKSPACE).Workspace window, window.$dom
    
    it 'should initialize its information based on the DOM', ->
      info = workspace.info()
      info.roomNumber.should_be 'fake room number'
      info.canvas.width.should_be 1024
      info.canvas.height.should_be 768
    
    it 'should update its information based on what is provided', ->
      workspace.setup canvas:
        width: 1920
        height: 1080
      
      info = workspace.info()
      info.canvas.width.should_be 1920
      info.canvas.height.should_be 1080

# DOM Mock Setup ---------------------------------------------------------------
DOLLARDOM = './lib/public/javascripts/libs/$dom.min.js'
fileSystem = require 'fs'
jsDom = require 'jsdom'
domUtilitySource = fileSystem.readFileSync(DOLLARDOM).toString()

jsDom.env
  html: '<room id="fake room number"/>'
  src: domUtilitySource
  done: (error, window) ->
    [window.innerWidth, window.innerHeight] = [1024, 768]
    specs window