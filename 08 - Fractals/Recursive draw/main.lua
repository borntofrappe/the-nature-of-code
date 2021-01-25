WINDOW_WIDTH = 520
WINDOW_HEIGHT = 520
RADIUS_MAX = 128
RADIUS_MIN = 4
LINE_WIDTH = 0.5

function love.load()
  love.window.setTitle("Fractals - Recursive draw")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.setLineWidth(LINE_WIDTH)
  draw(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, RADIUS_MAX)
end

function draw(x, y, r)
  love.graphics.circle("line", x, y, r)
  if r > RADIUS_MIN then
    draw(x, y, r / 2)
    draw(x + r, y, r / 2)
    draw(x - r, y, r / 2)
    draw(x, y + r, r / 2)
  end
end
