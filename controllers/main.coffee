module.exports = (app) ->

  app.get '/', (req, res) ->
    roomId = Date.now()
    res.redirect '/'+roomId

