LVector = require "LVector"
require "KochLine"

WINDOW_WIDTH = 560
WINDOW_HEIGHT = 480
PADDING = 20
LINE_WIDTH = 1
UPDATE_SPEED = 20

function love.load()
  love.window.setTitle("Fractals - Koch line")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  kochLine = KochLine:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    kochLine:generate()
  end
end

function love.update(dt)
  if love.mouse.isDown(2) then
    for i = 1, #kochLine.lines - 1 do
      local rx = math.random() * dt * UPDATE_SPEED
      local ry = math.random() * dt * UPDATE_SPEED
      if math.random() > 0.5 then
        rx = rx * -1
      end
      if math.random() > 0.5 then
        ry = ry * -1
      end
      local random = LVector:new(rx, ry)
      kochLine.lines[i].finish:add(random)
      if i > 1 then
        kochLine.lines[i].start = LVector:copy(kochLine.lines[i - 1].finish)
      end
    end
  end
end

function love.draw()
  kochLine:render()
end
