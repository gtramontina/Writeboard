helper = require './build/build_helper'
# Default ======================================================================
desc 'Runs the unit tests task'
task 'default', ['test:unit'], ->

# Tests ========================================================================
namespace 'test', ->
	desc 'Runs unit tests' # -----------------------------------------------------
	task 'unit', (jessieParams) ->
		jessie = './node_modules/jessie/bin/jessie'
		helper.execute "#{jessie} #{jessieParams ? '-f progress'} spec/unit"