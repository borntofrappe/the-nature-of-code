LVector = require "LVector"
require "Tree"

WINDOW_WIDTH = 540
WINDOW_HEIGHT = 480
UPDATE_SPEED = 20
ANGLE = math.pi / 8
LENGTH_INITIAL = 100
LENGTH_MULTIPLIER = 0.75
LENGTH_MIN = 5
LINEWIDTH_MAX = 7
LINEWIDTH_MIN = 1
LINEWIDTH_CHANGE = 2
function love.load()
  love.window.setTitle("Fractals - Tree - Object oriented")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  tree = Tree:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    tree:generate()
  end
  if button == 2 then
    tree = Tree:new()
  end
end

function love.draw()
  tree:render()
end

function drawLine(length, lineWidth)
  love.graphics.setLineWidth(lineWidth)
  love.graphics.line(0, 0, 0, -length)
  love.graphics.translate(0, -length)

  if length > LENGTH_MIN then
    length = length * 0.75
    lineWidth = math.max(LINE_WIDTH_MIN, lineWidth - LINE_WIDTH_CHANGE)
    love.graphics.push()
    love.graphics.rotate(angle)
    drawLine(length, lineWidth)
    love.graphics.pop()
    love.graphics.push()
    love.graphics.rotate(angle * -1)
    drawLine(length, lineWidth)
    love.graphics.pop()
  end
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
