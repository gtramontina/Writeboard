module.exports = (app) ->
  app.get '/:roomId', (request, response) -> response.render 'room', roomId: request.params.roomId