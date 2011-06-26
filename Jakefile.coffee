desc 'There is no default task; you need always to specify a task.'
task 'default', [], -> console.log 'There is no default task. Please run a specific task - \'jake --tasks\' to list existing tasks.'

server = require('./build/lib/server.coffee').Server
selenium = require('./build/lib/selenium.coffee').Selenium
test_runner = require('./build/lib/test_runner.coffee').Runner

namespace 'test', ->
  desc 'To run functional tests'
  task 'functional', () ->
    shutdown = () ->
      server_options.down()
      selenium_options.down()
    server_options = server()
    server_options.up()
    runner = test_runner('./spec/functional/', shutdown)
    selenium_options = selenium(runner.play)
    selenium_options.up()


  desc 'To run unit tests'
  task 'unit', ->
    process.argv.pop() for a in arguments
    file_system = require 'fs'
    process.argv.pop()
    process.chdir './test'
    #console.log (file_system.statSync process.cwd()+'/'+file).isDirectory() for file in file_system.readdirSync '.'
    process.argv = process.argv.concat file_system.readdirSync '.'
    process.argv.push '--spec'
    require 'vows/bin/vows'

task 'run', ->
  server().up()

task 'publish', ['test'], (build_number) ->
  if not build_number
    console.log 'You must specify a build_number'
    return

  console.log 'TODO: Copy to /build/published_artifacts/build_'+build_number

