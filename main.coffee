## Constants
framerate = 60
planetSz =
  X: 100
  Y: 100

## Constructors
Planet = (x,y) ->
  this.X = x
  this.Y = y

## Functions
fps = (d) -> 1000 / d

sizeCanvas = () ->
  canvas = document.getElementById('screen')
  canvas.style.width ='100%'
  canvas.style.height='98%'
  canvas.width  = canvas.offsetWidth
  canvas.height = canvas.offsetHeight

draw = (p) ->
  ctx = $('#screen')[0].getContext('2d')
  ctx.drawImage($('#POL')[0], p.X - (planetSz.X / 2), p.Y - (planetSz.Y / 2), planetSz.X, planetSz.Y)

## Streams
resize = $(window).asEventStream('resize')
clicksRaw = $('#screen').asEventStream('click')
tick = Bacon.interval(fps(framerate))

## Subscriptions
resize.onValue(sizeCanvas)

## Properties
planets = clicksRaw.scan([], (a,e) -> a.push(new Planet(e.offsetX, e.offsetY)); return a)

## Initialize
sizeCanvas()

## Game Loop
planets.sampledBy(tick).onValue((model) -> draw(planet) for planet in model)
