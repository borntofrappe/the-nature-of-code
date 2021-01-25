WINDOW_WIDTH = 520
WINDOW_HEIGHT = 260
LENGTH_MAX = 512
LENGTH_MIN = 1
LINE_WIDTH = 3
PADDING = 6
Y_GAP = (WINDOW_HEIGHT - PADDING * 2) / 6

function love.load()
  love.window.setTitle("Fractals - Cantor rule")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.setLineWidth(LINE_WIDTH)
  cantor(WINDOW_WIDTH / 2, PADDING, LENGTH_MAX)
end

function cantor(x, y, length)
  love.graphics.line(x - length / 2, y, x + length / 2, y)

  if length > LENGTH_MIN then
    cantor(x - length / 3, y + Y_GAP, length / 3)
    cantor(x + length / 3, y + Y_GAP, length / 3)
  end
end
