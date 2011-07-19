module.exports = (express) ->
	app = express.createServer()
	app.listen 9796
	return app