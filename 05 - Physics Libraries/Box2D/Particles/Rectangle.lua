Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:new(world, x, y)
  local body = love.physics.newBody(world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(SIZE, SIZE)
  local fixture = love.physics.newFixture(body, shape)

  local this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  setmetatable(this, self)
  return this
end

function Rectangle:render()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end
