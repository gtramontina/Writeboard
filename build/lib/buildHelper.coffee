child_process = require 'child_process'

exports.execute = (command) ->
  child_process.spawn '/bin/sh', ['-c', command], customFds: [0, 0, 0]

