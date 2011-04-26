@createWriteboard = (context) ->
  context.strokeStyle = 'rgb(20, 20, 20)'
  context.lineJoin = 'round'
  context.lineWidth = 5

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

