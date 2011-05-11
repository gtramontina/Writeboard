module.exports = (express, stylus, nib, nowjs) ->
  express.createServer();
  app = express.createServer();

  stylusCompiler = (str, path) ->
    (((stylus str)
    .set 'filename', path)
    .use nib())

  app.configure ->
    app.set 'view engine', 'jade'
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use app.router
    app.use stylus.middleware src: __dirname+'/public', compile: stylusCompiler
    app.use express.compiler src: __dirname+'/public', enable: ['coffeescript']
    app.use express.static __dirname+'/public'

  require('./controllers/writeboard') app, nowjs
  require('./controllers/room') app, nowjs

  app.listen 9796

