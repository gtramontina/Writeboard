module.exports = (app) ->

  app.get '/', (req, res) ->
    roomId = Date.now()
    res.redirect '/'+roomId

  app.get '/about', (req, res) ->
    parameters =
      if req.query.noLayout
        layout: false
      else layout: true, locals: title: 'Writeboard - About it!'
    res.render 'about', parameters

