WINDOW_WIDTH = 540
WINDOW_HEIGHT = 480
UPDATE_SPEED = 20
LENGTH_INITIAL = 100
ANGLE_MIN = math.pi / 8
ANGLE_MAX = math.pi / 4
LENGTH_MULTIPLIER_MIN = 0.55
LENGTH_MULTIPLIER_MAX = 0.85
LENGTH_MIN = 5
LINE_WIDTH_MAX = 7
LINE_WIDTH_MIN = 1
LINE_WIDTH_CHANGE = 2

function love.run()
  local hasDrawn = false

  if love.load then
    love.load(love.arg.parseGameArguments(arg), arg)
  end

  return function()
    if love.event then
      love.event.pump()
      for name, a, b, c, d, e, f in love.event.poll() do
        if name == "quit" then
          if not love.quit or not love.quit() then
            return a or 0
          end
        end
        love.handlers[name](a, b, c, d, e, f)
      end
    end

    if not hasDrawn then
      hasDrawn = true
      if love.graphics and love.graphics.isActive() then
        if love.draw then
          love.graphics.origin()
          love.graphics.clear(love.graphics.getBackgroundColor())
          love.draw()
          love.graphics.present()
        end
      end
    end
  end
end

function love.load()
  love.window.setTitle("Fractals - Tree - Stochastic")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
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

  local angle = math.random() * (ANGLE_MAX - ANGLE_MIN) + ANGLE_MIN
  if length > LENGTH_MIN then
    length = length * (math.random() * (LENGTH_MULTIPLIER_MAX - LENGTH_MULTIPLIER_MIN) + LENGTH_MULTIPLIER_MIN)
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
