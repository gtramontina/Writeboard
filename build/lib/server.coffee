child = require 'child_process'

server = ->
  node = ''
  up = ->
    node = child.spawn 'node', ['app.js']
    console.log 'Running Node JS server'
  down = ->
    console.log 'Shutting down'
    node.kill 'SIGHUP'
  server_options =
    up: up
    down: down

exports.Server = server
