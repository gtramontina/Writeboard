desc 'There is no default task; you need always to specify a task.'
task 'default', [], -> console.log 'There is no default task. Please run a specific task - \'jake --tasks\' to list existing tasks.'

task 'test', [], ->
  process.argv.pop() for a in arguments
  file_system = require 'fs'
  process.argv.pop()
  process.chdir './test'
  #console.log (file_system.statSync process.cwd()+'/'+file).isDirectory() for file in file_system.readdirSync '.'
  process.argv = process.argv.concat file_system.readdirSync '.'
  process.argv.push '--spec'
  require 'vows/bin/vows'

task 'publish', ['test'], (build_number) ->
  if not build_number
    console.log 'You must specify a build_number'
    return

  console.log 'TODO: Copy to /build/published_artifacts/build_'+build_number

