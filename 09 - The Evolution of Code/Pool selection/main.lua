require "DNA"
require "Population"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
-- maximum number of words stored in the _words_ collection
WORDS = 40

SIZE = 300
TARGET = "To be or not to be"
MUTATION_ODDS = 100

function love.load()
  love.window.setTitle("The evolution of code - Pool selection")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  population = Population:new(SIZE, TARGET, MUTATION_ODDS)

  fitnessRatio = 0
  words = {}
  foundIt = false
end

function love.update(dt)
  if not foundIt then
    population:reproduce()

    local bestMatch = population:getBestMatch()
    if bestMatch:getFitnessRatio(population.target) == 1 then
      foundIt = true
    end

    fitnessRatio = string.format("%.2f", bestMatch:getFitnessRatio(population.target))
    table.insert(words, bestMatch:getSentence())

    if #words > WORDS then
      table.remove(words, 1)
    end
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print("Sentence: " .. population.target, 8, 8)
  love.graphics.print("Generation: " .. population.generation, 8, 24)
  love.graphics.print("Population size: " .. population.size, 8, 40)
  love.graphics.print("Mutation odds: 1 in " .. population.mutationOdds, 8, 56)
  love.graphics.print("Fitness ratio: " .. fitnessRatio, 8, 72)

  for i = 1, #words do
    love.graphics.printf(words[#words - i + 1], 0, 8 + 12 * (i - 1), WINDOW_WIDTH - 8, "right")
  end
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
