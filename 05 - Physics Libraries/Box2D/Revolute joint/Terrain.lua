Terrain = {}
Terrain.__index = Terrain

function Terrain:new(world)
  local points = {}
  table.insert(points, 0)
  table.insert(points, 0)
  for i = 1, TERRAIN_POINTS do
    local x = (i - 1) * WINDOW_WIDTH / (TERRAIN_POINTS - 1)
    local y = TERRAIN_HEIGHT * -1
    table.insert(points, x)
    table.insert(points, y)
  end

  table.insert(points, WINDOW_WIDTH)
  table.insert(points, 0)

  local body = love.physics.newBody(world, 0, WINDOW_HEIGHT, "static")
  local shape = love.physics.newChainShape(false, points)
  local fixture = love.physics.newFixture(body, shape)

  local this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  setmetatable(this, self)
  return this
end

function Terrain:render()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end
