require "Turtle"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
LINE_WIDTH = 1
STEP_LENGTH = WINDOW_WIDTH / 8
ANGLE = math.rad(90)
GENERATIONS = 5
AXIOM = "F-F-F-F"
RULE = {
  ["F"] = "F[F]-F+F[--F]+F-F"
}

function love.load()
  love.window.setTitle("Fractals - L-system - Turtle - Fractal pattern")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  turtle = Turtle:new(STEP_LENGTH, ANGLE, AXIOM)
  for i = 1, GENERATIONS do
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

function love.draw()
  turtle:render()
end
