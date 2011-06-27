fs = require 'fs'
child = require 'child_process'

module.exports = (path, afterAllCallback)->
  execAll = (path, files)->
    if files.length is 0
      afterAllCallback()
    else
      console.log "test - " + path + files[0]
      test = child.spawn 'node', [path+files[0]]
      test.on 'exit', () ->
        execAll path, files[1..files.length]
  run = ->
    testFiles = fs.readdirSync path
    execAll path, testFiles

  # API
  play: run

