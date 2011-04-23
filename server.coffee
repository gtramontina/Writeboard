express = require 'express'
stylus = require 'stylus'
app = module.exports = express.createServer();

app.configure ->
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use stylus.middleware src: __dirname+'/public'
  app.use express.compiler src: __dirname+'/public', enable: ['coffeescript']
  app.use express.static __dirname+'/public'

app.get '/', (req, res) ->
  res.render 'writeboard', { title: 'Writeboard!' }

if module.parent? and module.parent.id is '.'
  app.listen 3000
  console.log 'Whiteboard listening on port 3000'

everyone = require('now').initialize app
everyone.now.addPoint = (x, y) ->
  everyone.now.draw x, y

