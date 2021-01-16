ComplexShape = {}
ComplexShape.__index = ComplexShape

function ComplexShape:new(world, x, y)
  local body = love.physics.newBody(world, x, y, "dynamic")

  local shape1 = love.physics.newRectangleShape(SIZE, SIZE / 4)
  local shape2 = love.physics.newRectangleShape(SIZE / 4, SIZE)
  local shapes = {shape1, shape2}

  local fixtures = {}
  for i, shape in ipairs(shapes) do
    local fixture = love.physics.newFixture(body, shape)
    table.insert(fixtures, fixture)
  end

  local this = {
    ["body"] = body,
    ["shapes"] = shapes,
    ["fixtures"] = fixtures
  }

  setmetatable(this, self)
  return this
end

function ComplexShape:render()
  love.graphics.setColor(0.11, 0.11, 0.11)

  for i, shape in ipairs(self.shapes) do
    love.graphics.polygon("fill", self.body:getWorldPoints(shape:getPoints()))
  end
end
