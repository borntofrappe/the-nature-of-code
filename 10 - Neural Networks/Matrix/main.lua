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

  m = Matrix:new(ROWS, COLUMNS)
  v = math.random(MAX_VALUE)
  operation = "+"
  m:add(v)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    operation = "+"
    v = math.random(MAX_VALUE)
    m:add(v)
  end

  if button == 2 then
    operation = "*"
    v = math.random(MAX_VALUE)
    m:multiply(v)
  end
end

function love.keypressed(key)
  if key == "a" then
    operation = "+"
    v = math.random(MAX_VALUE)
    m:add(v)
  end

  if key == "m" then
    operation = "*"
    v = math.random(MAX_VALUE)
    m:multiply(v)
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(m:getString(), 8, 8)
  love.graphics.printf(operation .. v, 0, 8, WINDOW_WIDTH - 8, "right")
end
