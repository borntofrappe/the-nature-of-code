require "Turtle"

WINDOW_WIDTH = 600
WINDOW_HEIGHT = 550
LINE_WIDTH = 1
STEP_LENGTH = 150
ANGLE = math.rad(25)
ANGLE_MIN = 15
ANGLE_MAX = 35
STEP_LENGTH_MIN = 130
STEP_LENGTH_MAX = 170
-- generation after which the turtle is reset
GENERATIONS_MAX = 5
AXIOM = "F"
--[[
  ! other characters are included as-is, so that the rule is actually
  RULE = {
    ["F"] = "FF+[+F-F-F]-[-F+F+F]",
    ["+"] = "+",
    ["-"] = "-",
    ["["] = "[",
    ["]"] = "]",
  }
]]
RULE = {
  ["F"] = "FF+[+F-F-F]-[-F+F+F]"
}

function love.load()
  love.window.setTitle("Fractals - L-system - Turtle - Tree")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  turtle = Turtle:new(STEP_LENGTH, ANGLE, AXIOM)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if turtle.generation > GENERATIONS_MAX then
      -- past the number of generations, reset the turtle with a random angle
      -- map the stepLength to have steeper angle match longer branches (steeper angles mean the tree extends less in the y dimension)
      local degrees = math.random(ANGLE_MIN, ANGLE_MAX)
      local angle = math.rad(degrees)
      if math.random() > 0.5 then
        angle = angle * -1
      end

      local stepLength = map(degrees, ANGLE_MIN, ANGLE_MAX, STEP_LENGTH_MIN, STEP_LENGTH_MAX)

      turtle = Turtle:new(stepLength, angle, AXIOM)
    else
      -- create new sentence and halve the step length
      local stepLength = turtle.stepLength
      local angle = turtle.angle
      local sentence = turtle.sentence
      local generation = turtle.generation

      stepLength = stepLength * 0.5
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

      turtle = Turtle:new(stepLength, angle, sentence, generation)
    end
  end
end

function love.draw()
  turtle:render()
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
