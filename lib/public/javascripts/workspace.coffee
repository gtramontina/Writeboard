root = exports ? @
root.Workspace = (domUtility) ->
  $ = domUtility
  info: ->
    roomNumber: $.get('room')[0].getAttribute 'id'