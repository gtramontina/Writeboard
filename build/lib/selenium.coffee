child = require 'child_process'

selenium = (callback) ->
  selenium_server = ''
  callback_selenium_ready = callback
  selenium_error_callback = (data) ->
    console.log 'ERROR loading selenium server - ' + data
  selenium_output_analyzer = (data) ->
    if ((data.search /Started SocketListener/i) >= 0)
      console.log 'Selenium ready'
      callback_selenium_ready()
  up = ->
    console.log 'Selenium Server going up...'
    selenium_server = child.spawn('java', ['-jar', 'vendor/selenium/selenium-server.jar'])
    selenium_server.stdout.setEncoding 'utf8'
    selenium_server.stdout.on 'data', selenium_output_analyzer
    selenium_server.stderr.setEncoding 'utf8'
    selenium_server.stderr.on 'data', selenium_error_callback
  down = ->
    selenium_server.kill 'SIGHUP'
  selenium_options =
    up: up
    down: down

exports.Selenium = selenium
