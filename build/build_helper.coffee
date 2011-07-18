childProcess 	= require 'child_process'
sys 					= require 'sys'

exports.execute = (command) ->
	childProcess.exec command, (error, stdout, stderr) ->
		sys.error error if error
		sys.puts stdout