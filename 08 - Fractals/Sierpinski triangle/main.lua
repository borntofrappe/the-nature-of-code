WINDOW_WIDTH = 520
WINDOW_HEIGHT = 520
SIDE_MAX = 512
SIDE_MIN = 8
LINE_WIDTH = 1

function love.load()
  love.window.setTitle("Fractals - Sierpinski triangle")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.setLineWidth(LINE_WIDTH)
  draw(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, SIDE_MAX)
end

function draw(x, y, side)
  local height = (side * 3 ^ 0.5) / 2
  love.graphics.line(
    x - side / 2,
    y + height / 2,
    x + side / 2,
    y + height / 2,
    x,
    y - height / 2,
    x - side / 2,
    y + height / 2
  )

  if side > SIDE_MIN then
    draw(x - side / 4, y + height / 4, side / 2)
    draw(x + side / 4, y + height / 4, side / 2)
    draw(x, y - height / 4, side / 2)
  end
end
