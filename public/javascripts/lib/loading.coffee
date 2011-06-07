@loading = (->
  overlay = undefined
  overlayDiv = ->
    return overlay if overlay?
    overlay = document.createElement 'div'
    overlay.setAttribute 'id', 'overlay-loading'
    overlay.style.opacity = 0
    overlay.style.display = 'none'
    overlay.appendChild messageSpan()
    document.body.appendChild overlay

  message = undefined
  messageSpan = ->
    return message if message?
    message = document.createElement 'span'

  # Built-in animations
  setOpacity = (element, level) -> element.style.opacity = level / 100
  animations =
    fadeIn : (element, callback) ->
      element.style.display = 'initial'
      change = (opacity) ->
        value = opacity
        setTimeout (-> setOpacity element, value), value*3
      change opacity for opacity in [5..100] by 5
      callback?()

    fadeOut: (element) ->
      change = (opacity, callback) ->
        value = opacity
        setTimeout (-> setOpacity element, value), (100-value)*3
      change opacity for opacity in [100..0] by -5
      callback?()

  showAnimation = (animation) ->
    showAnimation = animations[animation]

  hideAnimation = (animation) ->
    hideAnimation = animations[animation]

  showing = false
  show = (message) ->
    messageSpan().innerHTML = message
    (showing = true) and showAnimation overlayDiv() if not showing

  hide = ->
    showing = false
    hideAnimation overlayDiv(), -> element.style.display = 'none'


  # Defaults
  showAnimation 'fadeIn'
  hideAnimation 'fadeOut'

  # API
  show          : show
  hide          : hide
  showAnimation : showAnimation
  hideAnimation : hideAnimation
)()

