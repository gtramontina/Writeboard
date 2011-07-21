module.exports = (app) ->
  app.get '/:roomId', (_, response) -> response.render 'room'