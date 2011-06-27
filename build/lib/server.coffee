child = require 'child_process'

module.exports = ->
  node = undefined
  up = ->
    node = child.spawn 'node', ['app.js']
    console.log 'Running Node JS server'
  down = ->
    console.log 'Shutting down'
    node.kill 'SIGHUP'

  # API
  up: up
  down: down

