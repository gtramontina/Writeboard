module.exports = (express, stylus, nowjs) ->
  express.createServer();
  app = express.createServer();

  app.configure ->
    app.set 'view engine', 'jade'
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use app.router
    app.use stylus.middleware src: __dirname+'/public'
    app.use express.compiler src: __dirname+'/public', enable: ['coffeescript']
    app.use express.static __dirname+'/public'

  require('./controllers/main')(app)
  require('./controllers/room')(app, nowjs)

  if module.parent? and module.parent.id is '.'
    app.listen 3000
    console.log 'Whiteboard listening on port 3000'

  everyone = nowjs.initialize app
  everyone.now.joinRoom = (roomId, callback)->
    (nowjs.getGroup roomId).addUser @user.clientId
    callback()

