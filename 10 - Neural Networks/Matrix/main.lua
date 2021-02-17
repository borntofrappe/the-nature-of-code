require "Matrix"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

ROWS = 3
COLUMNS = 4
MAX_VALUE = 5

function love.load()
  love.window.setTitle("Neural networks - Matrix")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  m1 = Matrix:new(ROWS, COLUMNS)
  local v1 = math.random(MAX_VALUE)
  operation = "+"
  m1:add(v1)

  m2 = Matrix:new(ROWS, COLUMNS)
  local v2 = math.random(MAX_VALUE)
  m2:add(v2)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    operation = "+"
    m1:add(m2)
    m2:multiply(0)
    local v2 = math.random(MAX_VALUE)
    m2:add(v2)
  end

  if button == 2 then
    operation = "*"
    m1:multiply(m2)
    m2:multiply(0)
    local v2 = math.random(MAX_VALUE)
    m2:add(v2)
  end
end

function love.keypressed(key)
  if key == "a" then
    operation = "+"
    m1:add(m2)
    m2:multiply(0)
    local v2 = math.random(MAX_VALUE)
    m2:add(v2)
  end

  if key == "m" then
    operation = "*"
    m1:multiply(m2)
    m2:multiply(0)
    local v2 = math.random(MAX_VALUE)
    m2:add(v2)
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(m1:getString(), 8, 8)
  love.graphics.print(operation, 8, WINDOW_HEIGHT / 2)
  love.graphics.print(m2:getString(), 18, WINDOW_HEIGHT / 2)
end

function isInstance(instance, class)
  while instance do
    instance = getmetatable(instance)
    if instance == getmetatable(class) then
      return true
    end
  end
  return false
end
