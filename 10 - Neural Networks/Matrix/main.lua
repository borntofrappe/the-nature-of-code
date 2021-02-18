require "Matrix"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

ROWS = 2
COLUMNS = 3
MAX_VALUE = 10

function love.load()
  love.window.setTitle("Neural networks - Matrix")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  m1 = Matrix:new(ROWS, COLUMNS)
  m1.values = {
    {6, 7, 0},
    {7, 2, 6}
  }
  m2 = Matrix:new(COLUMNS, ROWS)
  m2.values = {
    {5, 3},
    {1, 1},
    {5, 1}
  }
end

function love.mousepressed(x, y, button)
  if button == 1 then
    m1:multiply(m2)
  end
end

function love.keypressed(key)
  if key == "m" then
    m1:multiply(m2)
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(m1:getString(), 8, 8)
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
