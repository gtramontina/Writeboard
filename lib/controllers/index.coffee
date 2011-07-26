module.exports = (app) ->
  app.get '/', (_, response) -> response.redirect "/#{Date.now()}"

  require('./room') app