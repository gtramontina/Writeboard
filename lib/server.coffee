module.exports = (express, stylus) ->

  stylusCompiler = (str, path) -> stylus(str)
    .set('filename', path)
    .use(nib())

  app = express.createServer(
    stylus.middleware(src: "#{__dirname}/public", compile: stylusCompiler),
    express.compiler( src: "#{__dirname}/public", enable: ['coffeescript']),
    express.static(   src: "#{__dirname}/public")
  )

  app.set 'views', "#{__dirname}/views"

  app.listen 9796
  return app