class Context
  constructor: (id, w, h) ->
    @canvas = document.getElementById id
    @canvas.width = w
    @canvas.height = h

    @ctx = @canvas.getContext '2d'

class Point
  constructor: (@x, @y) ->

  draw: ->
    @ctx.fillRect @x-2, @y-2,  4, 4


class Line
  constructor: (@point1, @point2) ->

  draw: ->
    @ctx.beginPath()
    @ctx.moveTo @point1.x, @point1.y
    @ctx.lineTo @point2.x, @point2.y
    @ctx.stroke()



window.addEventListener 'load', ->

  ctx = new Context 'canvas', 900, 600

  Line::ctx = ctx.ctx
  Point::ctx = ctx.ctx

  prevPoint = null
  draw = false

  ctx.canvas.addEventListener 'mousedown', (ev) ->
    draw = true
    prevPoint = point = new Point ev.clientX, ev.clientY
    point.draw()

  ctx.canvas.addEventListener 'mouseup', (ev) ->
    draw = false
    prevPoint = point = new Point ev.clientX, ev.clientY
    point.draw()

  ctx.canvas.addEventListener 'mousemove', (ev) ->
    return unless draw
    return if Math.random() > 0.4 # ratio of slow
    point = new Point ev.clientX, ev.clientY
    line = new Line point, prevPoint
    line.draw()
    prevPoint = point