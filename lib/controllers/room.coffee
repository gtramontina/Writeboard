module.exports = (app) ->
  app.get '/:roomNumber', (request, response) -> response.render 'room', roomNumber: request.params.roomNumber