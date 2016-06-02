## Constants
G = 9.81
framerate = 60

## Constructors
Planet = (x,y) ->
  this.X = x
  this.Y = y
  this.V = 0
  this.sX = 100
  this.sY = 100

## Functions
fps = (d) -> 1000 / d

animate = (p) ->
  apt = G / framerate # Acceleration Per Tick. Eventually tie this to the real tick not the ideal framerate.
  yBound = $('#screen')[0].height - (p.sY / 2)
  p.V += apt
  p.Y += p.V
  if (p.Y > yBound)
    p.Y = yBound
    p.V = -p.V

sizeCanvas = () ->
  canvas = $('#screen')[0]
  canvas.style.width ='100%'
  canvas.style.height='98%' # Why does 100% make the canvas bigger than the window?
  canvas.width  = canvas.offsetWidth
  canvas.height = canvas.offsetHeight

clear = () ->
  canvas = $('#screen')[0]
  ctx = canvas.getContext('2d')
  ctx.clearRect(0, 0, canvas.width, canvas.height);

draw = (p) ->
  canvas = $('#screen')[0]
  ctx = canvas.getContext('2d')
  ctx.drawImage($('#POL')[0], p.X - (p.sX / 2), p.Y - (p.sY / 2), p.sX, p.sY)

## Streams
resize = $(window).asEventStream('resize')
clicksRaw = $('#screen').asEventStream('click')
tick = Bacon.interval(fps(framerate))

## Subscriptions
resize.onValue(sizeCanvas)

## Properties
planets = clicksRaw.scan([], (a,e) -> a.concat(new Planet(e.offsetX, e.offsetY)))

## Initialize
sizeCanvas()

## Game Loop
planets.sampledBy(tick).onValue((model) ->
  clear()
  for planet in model
    animate(planet)
    draw(planet)
  )
