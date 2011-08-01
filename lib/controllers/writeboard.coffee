module.exports = (app, nowjs) ->

  app.get '/', (req, res) -> res.render 'index', layout: false

  app.get '/alpha/', (req, res) -> res.redirect "/alpha/#{Date.now()}"

  app.get '/about', (req, res) ->
    parameters =
      if req.query.noLayout
        layout: false
      else layout: true, locals: title: 'Writeboard - About it!'
    res.render 'about', parameters

  CouchClient = require 'couch-client'
  DEV_COUCH_URL = '/writeboard'
  interested = CouchClient(process.env.IRIS_COUCH_URL or DEV_COUCH_URL)
  app.post '/interested', (req, res) ->
    interested.save email: req.body.email, (error, doc) ->
      if error then res.send false, 500 else res.send true, 200

