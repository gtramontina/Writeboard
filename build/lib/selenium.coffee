child = require 'child_process'
fs = require 'fs'

module.exports = (callbackReady) ->
  seleniumServer = ''
  seleniumServer_url = 'http://selenium.googlecode.com/files/selenium-server-standalone-2.0rc2.jar'
  seleniumFolder = './vendor/selenium/'
  callbackSeleniumReady = callbackReady
  seleniumErrorCallback = (data) ->
    console.log 'ERROR loading selenium server - ' + data
  seleniumOutputAnalyzer = (data) ->
    if ((data.search /Started SocketListener/i) >= 0)
      console.log 'Selenium is downloaded and ready'
      callbackSeleniumReady()
  up = ->
    runAll = () ->
      console.log 'Selenium Server going up...'
      seleniumServer = child.spawn('java', ['-jar', 'vendor/selenium/selenium-server.jar'])
      seleniumServer.stdout.setEncoding 'utf8'
      seleniumServer.stdout.on 'data', seleniumOutputAnalyzer
      seleniumServer.stderr.setEncoding 'utf8'
      seleniumServer.stderr.on 'data', seleniumErrorCallback
    installDependenciesAndRun runAll
  down = ->
    seleniumServer.kill 'SIGHUP'
  isDependencies = ->
    console.log 'Verifying dependencies...'
    vendor_files = fs.readdirSync(seleniumFolder)
    'selenium-server.jar' in vendor_files
  installDependenciesAndRun = (callbackReady)->
    analyzer = (data) ->
      callbackReady() if (data.search(/saved/i) >=0)
    if(not isDependencies())
      console.log 'Downloading Selenium Server'
      wget = child.spawn('wget', [seleniumServer_url, '-O', seleniumFolder+'selenium-server.jar'])
      wget.stderr.setEncoding 'utf8'
      wget.stderr.on 'data', analyzer
    else
      callbackReady()
  # API
  up: up
  down: down

