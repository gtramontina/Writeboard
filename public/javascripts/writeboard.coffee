@createWriteboard = (canvas) ->
  colors =
    black : 'rgba(20, 20, 20, 0.8)'
    blue  : 'rgba(0, 0, 255, 0.8)'
    green : 'rgba(0, 150, 0, 0.8)'
    red   : 'rgba(255, 0, 0, 0.8)'
    eraser: 'rgb(0, 0, 0)'

  context = canvas.getContext '2d'
  [width, height] = [canvas.width, canvas.height]
  lastX = lastY = 0
  currentCanvasData = undefined
  currentColor = undefined

  setDefaults = ->
    context.lineJoin = context.lineCap = 'round'
    context.lineWidth = 2

  setColor = (color) ->
    [context.strokeStyle, currentColor] = [colors[color], color]
    context.globalCompositeOperation = if color is 'eraser' then 'destination-out' else 'source-over'

  getColor = -> currentColor

  startDrawing = (x, y) ->
    [lastX, lastY] = [x, y]
    context.beginPath()
    context.moveTo x, y
    currentCanvasData = context.getImageData 0, 0, width, height
    draw x+.1, y+.1

  draw = (x, y) ->
    context.clearRect 0, 0, width, height
    context.putImageData currentCanvasData, 0, 0
    context.quadraticCurveTo lastX, lastY,
      lastX + (x - lastX) / 2,
      lastY + (y - lastY) / 2
    context.stroke()
    [lastX, lastY] = [x, y]

  stopDrawing = ->
    lastX = lastY = 0

  takeSnapshot = ->
    canvas.toDataURL()

  splash = (snapshot, callback) ->
    image = new Image()
    image.onload = ->
      context.drawImage image, 0, 0
      callback()
    image.src = snapshot

  resize = (size) ->
    currentCanvasData = context.getImageData 0, 0, width, height
    lastColor = context.strokeStyle
    [canvas.width, canvas.height] = [width, height] = [size.width, size.height]
    context.putImageData currentCanvasData, 0, 0
    setDefaults()
    setColor lastColor

  # Initialize
  setDefaults()
  setColor 'black'

  # Writeboard API
  draw        : draw
  startDrawing: startDrawing
  stopDrawing : stopDrawing
  setColor    : setColor
  getColor    : getColor
  takeSnapshot: takeSnapshot
  splash      : splash
  resize      : resize

