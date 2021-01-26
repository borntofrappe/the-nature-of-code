WINDOW_WIDTH = 540
WINDOW_HEIGHT = 480

function love.load()
  love.window.setTitle("Fractals - L-system - Grammar")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  generations = {
    "A"
  }
  rule = {
    ["A"] = "ABA",
    ["B"] = "BBB"
  }
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local next = {}
    local current = generations[#generations]
    for i = 1, #current do
      next[#next + 1] = rule[current:sub(i, i)]
    end
    current = table.concat(next)
    table.insert(generations, current)
  end

  if button == 2 then
    generations = {
      "A"
    }
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.printf(generations[#generations], 0, 8, WINDOW_WIDTH, "center")
end
