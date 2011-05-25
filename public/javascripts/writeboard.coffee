@createWriteboard = (canvas) ->
  context = canvas.getContext '2d'
  context.lineJoin = 'round'
  context.lineCap = 'round'
  context.lineWidth = 2

  [width, height] = [canvas.width, canvas.height]
  lastX = lastY = 0
  lastCanvasData = undefined

  setColor = (color) -> context.strokeStyle = color

  startDrawing = (x, y) ->
    [lastX, lastY] = [x, y]
    context.beginPath()
    context.moveTo x, y
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

  stopDrawing = -> lastX = lastY = 0

  takeSnapshot = -> canvas.toDataURL()
  splash = (snapshot, callback) ->
    image = new Image()
    image.onload = ->
      context.drawImage image, 0, 0
      callback()
    image.src = snapshot

  setColor 'rgba(20, 20, 20, 0.8)'

  # Writeboard API
  draw        : draw
  startDrawing: startDrawing
  stopDrawing : stopDrawing
  setColor    : setColor
  takeSnapshot: takeSnapshot
  splash      : splash

