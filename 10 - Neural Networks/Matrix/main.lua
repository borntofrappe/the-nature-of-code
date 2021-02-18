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

  m = Matrix:new(ROWS, COLUMNS)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    m:transpose()
  end
end

function love.keypressed(key)
  if key == "t" then
    m:transpose()
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(m:getString(), 8, 8)
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
