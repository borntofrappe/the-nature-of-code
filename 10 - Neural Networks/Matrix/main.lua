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
  m1:randomize(MAX_VALUE)
  m2 = Matrix:new(ROWS, COLUMNS)
  m2:randomize(MAX_VALUE)
  m3 = Matrix:new(COLUMNS, ROWS)
  m3:randomize(MAX_VALUE)

  m = nil
  operation = ""
end

function double(m)
  return m * 2
end

function love.keypressed(key)
  if key == "r" then
    m1 = Matrix:new(ROWS, COLUMNS)
    m1:randomize(MAX_VALUE)
    m2 = Matrix:new(ROWS, COLUMNS)
    m2:randomize(MAX_VALUE)
    m3 = Matrix:new(COLUMNS, ROWS)
    m3:randomize(MAX_VALUE)
    m = nil
    operation = ""
  end

  if key == "a" then
    m = Matrix.Add(m1, m2)
    operation = "m1 + m2"
  end

  if key == "m" then
    m = Matrix.Multiply(m1, m2)
    operation = "m1 * m2"
  end

  if key == "p" then
    m = Matrix.Multiply(m1, m3)
    operation = "m1 * m3"
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  if m then
    love.graphics.print(operation, WINDOW_WIDTH / 2, 8)
    love.graphics.print(m:getString(), WINDOW_WIDTH / 2, 28)
  end
  love.graphics.print(m1:getString(), 8, 8)
  love.graphics.print(m2:getString(), 8, 58)
  love.graphics.print(m3:getString(), 8, 108)
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
