helper = require './build/lib/buildHelper'

desc "Please run a specific task - 'jake --tasks' to list existing tasks."
task 'default', [], -> console.log "Please run a specific task - 'jake --tasks' to list existing tasks."

# TESTING
namespace 'test', ->
  desc 'To run functional tests'
  task 'functional', () ->
    writeboardApp = require('./build/lib/server')()
    runner = require('./build/lib/testRunner') './spec/functional/', ->
      writeboardApp.down()
      selenium.down()
    selenium = require('./build/lib/selenium') runner.play

    writeboardApp.up()
    selenium.up()

  desc 'To run unit tests'
  task 'unit', ->
    helper.execute 'jessie spec/unit'

# RUN
desc 'To run the http server'
task 'run', ->
  helper.execute 'node app.js'

# PUBLISH
desc 'To make the project artifacts ready for deploy'
task 'publish', ['test:unit'], (build_number) ->
  if not build_number
    console.log 'You must specify a build_number'
    return
  console.log 'TODO: Copy to /build/published_artifacts/build_'+build_number

