WINDOW_WIDTH = 520
WINDOW_HEIGHT = 260
LINE_WIDTH = 3
PADDING = 6
GENERATIONS = 6
Y_GAP = (WINDOW_HEIGHT - PADDING * 2) / 6

function love.load()
  love.window.setTitle("Fractals - L-system - Cantor rule")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  generations = {
    "A"
  }
  rule = {
    ["A"] = "ABA",
    ["B"] = "BBB"
  }

  for i = 1, GENERATIONS do
    local next = {}
    local current = generations[#generations]
    for i = 1, #current do
      next[#next + 1] = rule[current:sub(i, i)]
    end
    current = table.concat(next)
    table.insert(generations, current)
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH)
  for i, generation in ipairs(generations) do
    love.graphics.push()
    local segment = WINDOW_WIDTH / #generation
    for j = 1, #generation do
      local character = generation:sub(j, j)
      if character == "A" then
        love.graphics.line(0, PADDING, segment, PADDING)
        love.graphics.translate(segment, 0)
      elseif character == "B" then
        love.graphics.translate(segment, 0)
      end
    end
    love.graphics.pop()
    love.graphics.translate(0, Y_GAP)
  end
end
