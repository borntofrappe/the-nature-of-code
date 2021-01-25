LVector = require "LVector"
require "KochLine"

WINDOW_WIDTH = 520
WINDOW_HEIGHT = 520
PADDING = 20
LINE_WIDTH = 1
UPDATE_SPEED = 20
RADIUS = 180
SIDES = 3
APOTHEM = RADIUS * (math.cos(math.pi / SIDES))
SIDE = 2 * RADIUS * math.sin(math.pi / SIDES)
GENERATIONS = 5

function love.load()
  love.window.setTitle("Fractals - Koch snowflake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  kochLines = {}
  local angle = math.rad(360 / SIDES)
  local x = WINDOW_WIDTH / 2 - SIDE / 2
  local y = WINDOW_HEIGHT / 2 - APOTHEM
  local start = LVector:new(x, y)
  local side = LVector:new(SIDE, 0)
  for i = 1, SIDES do
    local finish = LVector:add(start, side)
    table.insert(kochLines, KochLine:new(start, finish))
    start = LVector:copy(finish)
    side:rotate(angle)
  end

  for i = 1, GENERATIONS do
    for i, kochLine in ipairs(kochLines) do
      kochLine:generate()
    end
  end
end

function love.draw()
  for i, kochLine in ipairs(kochLines) do
    kochLine:render()
  end
end
