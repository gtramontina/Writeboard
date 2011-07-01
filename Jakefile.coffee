JESSIE_PATH = './node_modules/jessie/bin'

helper = require './build/lib/buildHelper'
sys = require 'sys'

# DEFAULT ======================================================================
desc "Please run a specific task - 'jake --tasks' to list existing tasks."
task 'default', [], -> console.log "Please run a specific task - 'jake --tasks' to list existing tasks."

# TEST =========================================================================
namespace 'test', ->
  # Functional -----------------------------------------------------------------
  desc 'To run functional tests'
  task 'functional', () ->
    writeboardApp = require('./build/lib/server')()
    runner = require('./build/lib/testRunner') './spec/functional/', ->
      writeboardApp.down()
      selenium.down()
    selenium = require('./build/lib/selenium') runner.play

    writeboardApp.up()
    selenium.up()

  # Unit -----------------------------------------------------------------------
  desc 'To run unit tests'
  task 'unit', (xmlFileName) ->
    helper.execute "#{JESSIE_PATH}/jessie spec/unit"

  # XUnit ----------------------------------------------------------------------
  desc 'To run unit tests and send the results to'
  task 'xunit', (xmlFileName) ->
    if not xmlFileName
      sys.puts "\033[31mFile path required.\033[0m"
      sys.puts '  Usage: jake test:xunit <path/to/file.xml>'
    else helper.execute "#{JESSIE_PATH}/jessie -f xunit spec/unit | cat > #{xmlFileName}"

# RUN ==========================================================================
desc 'To run the http server'
task 'run', ->
  helper.execute 'node app.js'

# PUBLISH ======================================================================
desc 'To make the project artifacts ready for deploy'
task 'publish', ['test:unit'], (build_number) ->
  if not build_number
    console.log 'You must specify a build_number'
    return
  console.log 'TODO: Copy to /build/published_artifacts/build_'+build_number

