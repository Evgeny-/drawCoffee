class Context
  constructor: (id, @w, @h) ->
    @canvas = document.getElementById id
    @canvas.width = @w
    @canvas.height = @h

    @ctx = @canvas.getContext '2d'

  setBg: (color) ->
    @ctx.fillStyle = color;
    @ctx.fillRect 0, 0, @w, @h

  setColor: (color) ->
    @ctx.strokeStyle = color;


class Point
  color = 'rgb(255,255,245)'
  constructor: (@x, @y) ->

  draw: ->
    @ctx.fillStyle = color;
    @ctx.fillRect @x-1, @y-1,  3, 3


class Line
  constructor: (@point1, @point2) ->

  draw: ->
    @ctx.beginPath()
    @ctx.moveTo @point1.x, @point1.y
    @ctx.lineTo @point2.x, @point2.y
    @ctx.stroke()



window.addEventListener 'load', ->

  ctx = new Context 'canvas', window.innerWidth, window.innerHeight - 5
  ctx.setBg 'rgb(111, 78, 55)'
  ctx.setColor 'rgb(250,250,255)'

  Line::ctx = ctx.ctx
  Point::ctx = ctx.ctx

  prevPoint = null
  draw = false

  ctx.canvas.addEventListener 'mousedown', (ev) ->
    draw = true
    prevPoint = new Point ev.clientX, ev.clientY
    prevPoint.draw()

  ctx.canvas.addEventListener 'mouseup', (ev) ->
    draw = false
    prevPoint.draw()
    prevPoint = new Point ev.clientX, ev.clientY

  ctx.canvas.addEventListener 'mousemove', (ev) ->
    return if not draw or Math.random() > 0.4
    point = new Point ev.clientX, ev.clientY
    line = new Line point, prevPoint
    line.draw()
    prevPoint = point