require "KochLine"

Snowflake = {}
Snowflake.__index = Snowflake

function Snowflake:new(sides, generations)
  local sides = sides or SIDES
  local generations = generations or GENERATIONS
  local apothem = RADIUS * (math.cos(math.pi / sides))
  local side = 2 * RADIUS * math.sin(math.pi / sides)

  kochLines = {}
  local angle = math.rad(360 / sides)
  local x = WINDOW_WIDTH / 2 - side / 2
  local y = WINDOW_HEIGHT / 2 - apothem
  local start = LVector:new(x, y)
  local side = LVector:new(side, 0)
  for i = 1, sides do
    local finish = LVector:add(start, side)
    table.insert(kochLines, KochLine:new(start, finish))
    start = LVector:copy(finish)
    side:rotate(angle)
  end

  for i = 1, generations do
    for i, kochLine in ipairs(kochLines) do
      kochLine:generate()
    end
  end

  local this = {
    ["kochLines"] = kochLines
  }

  setmetatable(this, self)
  return this
end

function Snowflake:render()
  for i, kochLine in ipairs(self.kochLines) do
    kochLine:render()
  end
end
