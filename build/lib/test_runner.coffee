fs = require 'fs'
child = require 'child_process'

runner = (path, after_all_callback)->
  exec_all = (path, files)->
    if files.length is 0
      after_all_callback()
    else
      console.log "test - " + path + files
      test = child.spawn 'node', [path+files[0]]
      test.on 'exit', () ->
        exec_all path, files[1..files.length]  
  run = ->
    test_files = fs.readdirSync path 
    exec_all path, test_files
  options = 
    play: run

exports.Runner = runner
