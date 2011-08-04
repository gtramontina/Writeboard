root = exports ? @
root.Workspace = (window, domUtility) ->
  $ = domUtility
  
  currentInfo =
    roomNumber: $.get('room')[0].getAttribute 'id'
    canvas:
      width: window.innerWidth
      height: window.innerHeight

  info: -> currentInfo
  setup: (info) ->
    currentInfo.canvas.width = info.canvas.width
    currentInfo.canvas.height = info.canvas.height