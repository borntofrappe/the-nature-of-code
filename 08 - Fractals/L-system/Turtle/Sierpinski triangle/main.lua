require "Turtle"

WINDOW_WIDTH = 550
WINDOW_HEIGHT = 550
PADDING = 25
LINE_WIDTH = 1
STEP_LENGTH = WINDOW_WIDTH
ANGLE = math.rad(60)
-- generation after which the turtle is reset
GENERATIONS_MAX = 7
AXIOM = "F--F--F"
RULE = {
  ["F"] = "F--F--F--GG",
  ["G"] = "GG"
}

function love.load()
  love.window.setTitle("Fractals - L-system - Turtle - Sierpinski triangle")
  love.window.setMode(WINDOW_WIDTH + PADDING * 2, WINDOW_HEIGHT + PADDING * 2)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  local turtle = Turtle:new(STEP_LENGTH, 0, ANGLE, AXIOM)
  turtles = {turtle}
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if #turtles > GENERATIONS_MAX then
      local turtle = Turtle:new(STEP_LENGTH, 0, ANGLE, AXIOM)
      turtles = {turtle}
    else
      -- create new turtle and halve the step length
      local previousTurtle = turtles[#turtles]

      local x = previousTurtle.x
      local y = previousTurtle.y
      local angle = previousTurtle.angle
      local sentence = previousTurtle.sentence
      local generation = previousTurtle.generation

      x = x * 0.5
      generation = generation + 1

      local nextSentence = {}
      for i = 1, #sentence do
        local character = sentence:sub(i, i)
        local ruleCharacter = RULE[character]
        if ruleCharacter then
          nextSentence[#nextSentence + 1] = ruleCharacter
        else
          nextSentence[#nextSentence + 1] = character
        end
      end
      sentence = table.concat(nextSentence)

      local turtle = Turtle:new(x, y, angle, sentence, generation)
      table.insert(turtles, turtle)
    end
  end
end

function love.draw()
  -- draw last turtle from the bottom left of the window
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.translate(PADDING, WINDOW_HEIGHT - PADDING)
  turtles[#turtles]:render()
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
