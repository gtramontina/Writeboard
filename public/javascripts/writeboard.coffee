@createWriteboard = (context) ->
  context.strokeStyle = 'rgb(200, 0, 0)'
  context.lineJoin = 'round'
  context.lineWidth = 20

  draw = (x, y) ->
    context.lineTo x, y
    context.stroke()
  startDrawing = (x, y) ->
    context.beginPath()
    context.moveTo x, y
  stopDrawing = ->
    context.closePath()

  # Writeboard API
  draw        : draw,
  startDrawing: startDrawing,
  stopDrawing : stopDrawing

