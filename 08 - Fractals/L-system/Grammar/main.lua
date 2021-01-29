WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

AXIOM = "A"
RULE = {
  ["A"] = "ABA",
  ["B"] = "BBB"
}
GENERATIONS_MAX = 5

function love.load()
  love.window.setTitle("Fractals - L-system - Grammar")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  sentence = AXIOM
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local next = {}
    for i = 1, #sentence do
      next[#next + 1] = RULE[sentence:sub(i, i)]
    end
    sentence = table.concat(next)
  end

  if button == 2 then
    sentence = AXIOM
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.printf(sentence, 2, 0, WINDOW_WIDTH, "left")
end
