$about = $ '#about'
$('#overlay').click ->
  $about.fadeOut 200, -> $about.remove()

