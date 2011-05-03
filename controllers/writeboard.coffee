module.exports = (app, nowjs) ->

  app.get '/', (req, res) -> res.redirect '/'+Date.now()

  app.get '/about', (req, res) ->
    parameters =
      if req.query.noLayout
        layout: false
      else layout: true, locals: title: 'Writeboard - About it!'
    res.render 'about', parameters

