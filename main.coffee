class Context
  constructor: (id, @w, @h) ->
    @canvas = document.getElementById id
    @canvas.width = @w
    @canvas.height = @h

    @ctx = @canvas.getContext '2d'

  setBg: (color) ->
    @ctx.fillStyle = color
    @ctx.fillRect 0, 0, @w, @h

  getBg: ->
    @ctx.fillStyle

  setColor: (color) ->
    @ctx.strokeStyle = color

  getColor: ->
    @ctx.strokeStyle

  setWidth: (width) ->
    @ctx.lineWidth = width

  getWidth: ->
    @ctx.lineWidth or 1


class Point
  constructor: (@x, @y) ->

  draw: ->
    @ctx.fillStyle = 'rgb(255,255,245)';
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
  ctx.setColor 'rgb(255,255,255)'

  Line::ctx = ctx.ctx
  Point::ctx = ctx.ctx

  prevPoint = null
  draw = false
  drawRatio = 0.7

  ctx.canvas.addEventListener 'mousedown', (ev) ->
    draw = true
    prevPoint = new Point ev.layerX, ev.layerY
    #prevPoint.draw()

  ctx.canvas.addEventListener 'mouseup', ->
    draw = false
    #prevPoint.draw()

  ctx.canvas.addEventListener 'mousemove', (ev) ->
    return if not draw or Math.random() < drawRatio
    point = new Point ev.layerX, ev.layerY
    line = new Line point, prevPoint
    line.draw()
    prevPoint = point

  drawRatioElement = document.getElementById 'draw-ratio'
  drawRatioElement.value = drawRatio
  drawRatioElement.addEventListener 'change', (ev) ->
    if 0 <= +ev.target.value <= 1
      drawRatio = +ev.target.value
    else
      alert 'must be from 0 to 1'
      drawRatioElement.value = drawRatio

  lineWidthElement = document.getElementById 'line-width'
  lineWidthElement.value = ctx.getWidth()
  lineWidthElement.addEventListener 'change', (ev) ->
    if 0 <= +ev.target.value < 150
      ctx.setWidth +ev.target.value
    else
      alert 'must be from 0 to 150'
      ev.target.value = ctx.getWidth()

  colorElement = document.getElementById 'color'
  colorElement.value = ctx.getColor()
  colorElement.addEventListener 'change', (ev) ->
    ctx.setColor ev.target.value

  bgElement = document.getElementById 'background'
  bgElement.value = ctx.getBg()
  bgElement.addEventListener 'change', (ev) ->
    ctx.setBg ev.target.value

  document.getElementById('clear').addEventListener 'click', ->
    ctx.setBg bgElement.value

  document.getElementById('save').addEventListener 'click', ->
    window.location = ctx.canvas.toDataURL "image/png"

  document.getElementById('image').addEventListener 'change', (ev) ->
    reader = new FileReader
    reader.onload = (event) ->
      img = new Image();
      img.onload = ->
        ctx.canvas.width = img.width
        ctx.canvas.height = img.height
        ctx.ctx.drawImage img, 0 ,0
        ctx.setColor colorElement.value
      img.src = event.target.result
    reader.readAsDataURL ev.target.files[0]