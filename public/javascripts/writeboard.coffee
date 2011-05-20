@createWriteboard = (canvas, width, height) ->
  [canvas.width, canvas.height] = [width, height]
  context = canvas.getContext '2d'
  context.lineJoin = 'round'
  context.lineCap = 'round'
  context.lineWidth = 2

  lastX = lastY = 0
  lastCanvasData = undefined

  setColor = (color) -> context.strokeStyle = color

  startDrawing = (x, y) ->
    [lastX, lastY] = [x, y]
    context.beginPath()
    lastCanvasData = context.getImageData 0, 0, width, height
    draw x+.1, y+.1

  draw = (x, y) ->
    context.clearRect 0, 0, width, height
    context.putImageData lastCanvasData, 0, 0
    context.quadraticCurveTo lastX, lastY,
      lastX + (x - lastX) / 2,
      lastY + (y - lastY) / 2
    context.stroke()
    [lastX, lastY] = [x, y]

  stopDrawing = -> # ?

  setColor 'rgba(20, 20, 20, 0.8)'

  # Writeboard API
  draw        : draw
  startDrawing: startDrawing
  stopDrawing : stopDrawing
  setColor    : setColor

