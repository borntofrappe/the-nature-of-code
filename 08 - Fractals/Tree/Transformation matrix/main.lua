WINDOW_WIDTH = 540
WINDOW_HEIGHT = 480
UPDATE_SPEED = 20
LENGTH_INITIAL = 100
ANGLE_INITIAL = math.pi / 8
LENGTH_MIN = 5
LINE_WIDTH_MAX = 7
LINE_WIDTH_MIN = 1
LINE_WIDTH_CHANGE = 2

function love.load()
  love.window.setTitle("Fractals - Tree")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  angle = ANGLE_INITIAL
end

function love.update(dt)
  local x, y = love.mouse:getPosition()

  if x > 0 and x < WINDOW_WIDTH then
    angle = map(x, 0, WINDOW_WIDTH, 0, math.pi / 2)
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT)
  drawLine(LENGTH_INITIAL, LINE_WIDTH_MAX)
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
