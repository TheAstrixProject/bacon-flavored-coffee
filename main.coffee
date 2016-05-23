sizeCanvas = () ->
  canvas = document.getElementById("screen")
  canvas.style.width ='100%'
  canvas.style.height='98%'
  canvas.width  = canvas.offsetWidth
  canvas.height = canvas.offsetHeight

$('#screen')[0].addEventListener("load", sizeCanvas())

clicksRaw = $('#screen').asEventStream('click')
clicks = clicksRaw.map((e) -> { X: e.offsetX, Y: e.offsetY})
clicks.onValue((c) -> 
  ctx = $('#screen')[0].getContext("2d")
  sz = { X: 100, Y: 100}
  ctx.drawImage($('#POL')[0], c.X - (sz.X / 2), c.Y - (sz.Y / 2), sz.X, sz.Y)
  )
