## Constants
G = 9.81
framerate = 60

## Constructors
Vector2 = (x,y) ->
  this.X = x
  this.Y = y
  this.add = (v) ->
    return (new Vector2(this.X + v.X, this.Y + v.Y))
  return this

Planet = (x,y) ->
  this.X = x
  this.Y = y
  this.V = 0
  this.sX = 100
  this.sY = 100
  return this

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
  canvas.style.height='95%' # Why does 100% make the canvas bigger than the window?
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
reset = $('#reset').asEventStream('click').map('reset')
combinedInput = clicksRaw.merge(reset)
tick = Bacon.interval(fps(framerate))

## Subscriptions
resize.onValue(sizeCanvas)

## Properties
planets = combinedInput.scan([], (a,e) ->
  if e == 'reset'
    return []
  else
    a.concat(new Planet(e.offsetX, e.offsetY)))

## Initialize
sizeCanvas()

## Game Loop
planets.sampledBy(tick).onValue((model) ->
  clear()
  for planet in model
    animate(planet)
    draw(planet)
  )
