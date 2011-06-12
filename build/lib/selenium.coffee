child = require 'child_process'
fs = require 'fs'

selenium = (callback_ready) ->
  selenium_server = ''
  selenium_server_url = 'http://selenium.googlecode.com/files/selenium-server-standalone-2.0rc2.jar'
  selenium_folder = './vendor/selenium/'
  callback_selenium_ready = callback_ready
  selenium_error_callback = (data) ->
    console.log 'ERROR loading selenium server - ' + data
  selenium_output_analyzer = (data) ->
    if ((data.search /Started SocketListener/i) >= 0)
      console.log 'Selenium is downloaded and ready'
      callback_selenium_ready()
  up = ->
    runAll = () ->
      console.log 'Selenium Server going up...'
      selenium_server = child.spawn('java', ['-jar', 'vendor/selenium/selenium-server.jar'])
      selenium_server.stdout.setEncoding 'utf8'
      selenium_server.stdout.on 'data', selenium_output_analyzer
      selenium_server.stderr.setEncoding 'utf8'
      selenium_server.stderr.on 'data', selenium_error_callback
    installDependenciesAndRun runAll
  down = ->
    selenium_server.kill 'SIGHUP'
  isDependencies = ->
    console.log 'Verifying dependencies...'
    vendor_files = fs.readdirSync(selenium_folder)
    'selenium-server.jar' in vendor_files
  installDependenciesAndRun = (callback_ready)->    
    analyzer = (data) ->
      callback_ready() if (data.search(/saved/i) >=0)
    if(not isDependencies())
      console.log 'Downloading Selenium Server'
      wget = child.spawn('wget', [selenium_server_url, '-O', selenium_folder+'selenium-server.jar'])
      wget.stderr.setEncoding 'utf8'
      wget.stderr.on 'data', analyzer
    else
      callback_ready()
  selenium_options =
    up: up
    down: down

exports.Selenium = selenium
