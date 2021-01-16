Terrain = {}
Terrain.__index = Terrain

function Terrain:new(world)
  local hills = {}

  for h = 1, HILLS do
    local points = {}
    for i = 1, HILL_POINTS + 1 do
      local x = (h - 1) * (WINDOW_WIDTH / HILLS) + (i - 1) * (WINDOW_WIDTH / HILLS) / HILL_POINTS
      local a = (h - 1) * math.pi + (i - 1) * (math.pi) / HILL_POINTS
      local y = math.cos(a) * AMPLITUDE * -1 - AMPLITUDE
      table.insert(points, x)
      table.insert(points, y)
    end

    local body = love.physics.newBody(world, 0, WINDOW_HEIGHT, "static")
    local shape = love.physics.newChainShape(false, points)
    local fixture = love.physics.newFixture(body, shape)
    local hill = {
      ["body"] = body,
      ["shape"] = shape,
      ["fixture"] = fixture
    }
    table.insert(hills, hill)
  end

  local this = {
    ["hills"] = hills,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  setmetatable(this, self)
  return this
end

function Terrain:render()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.setLineWidth(LINE_WIDTH)
  for i, hill in ipairs(self.hills) do
    love.graphics.polygon("line", hill.body:getWorldPoints(hill.shape:getPoints()))
  end
end
