(function() {
  this.createWriteboard = function(canvas) {
    var colors, context, currentCanvasData, currentColor, draw, getColor, height, lastX, lastY, resize, setColor, setDefaults, splash, startDrawing, stopDrawing, takeSnapshot, width, _ref;
    colors = {
      black: 'rgba(20, 20, 20, 0.8)',
      blue: 'rgba(0, 0, 255, 0.8)',
      green: 'rgba(0, 150, 0, 0.8)',
      red: 'rgba(255, 0, 0, 0.8)',
      eraser: 'rgb(0, 0, 0)'
    };
    context = canvas.getContext('2d');
    _ref = [canvas.width, canvas.height], width = _ref[0], height = _ref[1];
    lastX = lastY = 0;
    currentCanvasData = void 0;
    currentColor = void 0;
    setDefaults = function() {
      context.lineJoin = context.lineCap = 'round';
      return context.lineWidth = 2;
    };
    setColor = function(color) {
      var _ref2;
      _ref2 = [colors[color], color], context.strokeStyle = _ref2[0], currentColor = _ref2[1];
      return context.globalCompositeOperation = color === 'eraser' ? 'destination-out' : 'source-over';
    };
    getColor = function() {
      return currentColor;
    };
    startDrawing = function(x, y) {
      var _ref2;
      _ref2 = [x, y], lastX = _ref2[0], lastY = _ref2[1];
      context.beginPath();
      context.moveTo(x, y);
      currentCanvasData = context.getImageData(0, 0, width, height);
      return draw(x + .1, y + .1);
    };
    draw = function(x, y) {
      var _ref2;
      context.clearRect(0, 0, width, height);
      context.putImageData(currentCanvasData, 0, 0);
      context.quadraticCurveTo(lastX, lastY, lastX + (x - lastX) / 2, lastY + (y - lastY) / 2);
      context.stroke();
      return _ref2 = [x, y], lastX = _ref2[0], lastY = _ref2[1], _ref2;
    };
    stopDrawing = function() {
      return lastX = lastY = 0;
    };
    takeSnapshot = function() {
      return canvas.toDataURL();
    };
    splash = function(snapshot, callback) {
      var image;
      image = new Image();
      image.onload = function() {
        context.drawImage(image, 0, 0);
        return callback();
      };
      return image.src = snapshot;
    };
    resize = function(size) {
      var lastColor, _ref2, _ref3;
      currentCanvasData = context.getImageData(0, 0, width, height);
      lastColor = context.strokeStyle;
      _ref3 = (_ref2 = [size.width, size.height], width = _ref2[0], height = _ref2[1], _ref2), canvas.width = _ref3[0], canvas.height = _ref3[1];
      context.putImageData(currentCanvasData, 0, 0);
      setDefaults();
      return setColor(lastColor);
    };
    setDefaults();
    setColor('black');
    return {
      draw: draw,
      startDrawing: startDrawing,
      stopDrawing: stopDrawing,
      setColor: setColor,
      getColor: getColor,
      takeSnapshot: takeSnapshot,
      splash: splash,
      resize: resize
    };
  };
}).call(this);
