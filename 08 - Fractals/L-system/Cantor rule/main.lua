WINDOW_WIDTH = 500
WINDOW_HEIGHT = 250
LINE_WIDTH = 4
LINE_WIDTH_SPACING = LINE_WIDTH * 4

AXIOM = "A"
RULE = {
  ["A"] = "ABA",
  ["B"] = "BBB"
}
GENERATIONS_MAX = 5

function love.load()
  love.window.setTitle("Fractals - L-system - Cantor rule")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  sentence = AXIOM
  generations = {sentence}
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if #generations > GENERATIONS_MAX then
      sentence = AXIOM
      generations = {sentence}
    else
      local next = {}
      for i = 1, #sentence do
        next[#next + 1] = RULE[sentence:sub(i, i)]
      end
      sentence = table.concat(next)
      table.insert(generations, sentence)
    end
  end

  if button == 2 then
    sentence = "A"
  end
end

function love.draw()
  -- love.graphics.setColor(0.11, 0.11, 0.11, 1)
  -- love.graphics.printf(sentence, 2, 0, WINDOW_WIDTH, "center")

  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH)
  for i, generation in ipairs(generations) do
    love.graphics.push()
    love.graphics.translate(
      0,
      WINDOW_HEIGHT / 2 - LINE_WIDTH / 2 - (math.floor(#generations / 2) - i - 1) * LINE_WIDTH_SPACING
    )
    local segment = WINDOW_WIDTH / #generation
    for j = 1, #generation do
      local character = generation:sub(j, j)
      if character == "A" then
        love.graphics.line(0, 0, segment, 0)
        love.graphics.translate(segment, 0)
      elseif character == "B" then
        love.graphics.translate(segment, 0)
      end
    end
    love.graphics.pop()
  end
end
