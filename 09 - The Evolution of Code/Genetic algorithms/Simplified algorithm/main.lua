WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
-- maximum number of words stored in the _words_ collection
WORDS = 40

START = "a"
FINISH = "z"
SENTENCE = "fabulous"
POPULATION = 200
MUTATION_ODDS = 100

function love.load()
  love.window.setTitle("Genetic algorithms - Simplified algorithm")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  sentence = SENTENCE
  population = getPopulation(POPULATION)
  generations = 0
  fitnessRatio = 0
  words = {}

  foundIt = false
end

function getRandomCharacter()
  local start = string.byte(START)
  local finish = string.byte(FINISH)

  return string.char(math.random(start, finish))
end

function getRandomWord(length)
  local word = {}
  for i = 1, length do
    word[#word + 1] = getRandomCharacter()
  end

  return table.concat(word)
end

function getPopulation(size)
  local population = {}
  for i = 1, size do
    local word = getRandomWord(#sentence)
    table.insert(population, word)
  end

  return population
end

function getFitness(word, sentence)
  local fitness = 0
  for i = 1, #sentence do
    if word:sub(i, i) == sentence:sub(i, i) then
      fitness = fitness + 1
    end
  end

  return fitness
end

function getSelection(population, sentence)
  local selection = {}

  for i, word in ipairs(population) do
    local fitness = getFitness(word, sentence)
    for j = 1, fitness do
      table.insert(selection, word)
    end
  end

  -- ensure that the collection has at least two elements
  while #selection < 1 do
    table.insert(selection, population[math.random(#population)])
  end

  return selection
end

function getParents(selection)
  local index1 = math.random(#selection)
  local index2
  repeat
    index2 = math.random(#selection)
  until index2 ~= index1
  return selection[index1], selection[index2]
end

function getChild(selection)
  local p1, p2 = getParents(selection)

  local child = {}

  for i = 1, #sentence do
    if math.random(MUTATION_ODDS) == 1 then
      child[#child + 1] = getRandomCharacter()
    else
      child[#child + 1] = i % 2 == 1 and p1:sub(i, i) or p2:sub(i, i)
    end
  end

  return table.concat(child)
end

function love.update(dt)
  if not foundIt then
    local selection = getSelection(population, sentence)
    for i = 1, #population do
      local child = getChild(selection)
      population[i] = child
    end

    local bestFit = {
      ["value"] = 0,
      ["index"] = 0
    }

    for i = 1, #population do
      local fitness = getFitness(population[i], sentence)
      if fitness > bestFit.value then
        bestFit.value = fitness
        bestFit.index = i
      end
      if fitness == #sentence then
        foundIt = true
        break
      end
    end

    generations = generations + 1
    fitnessRatio = string.format("%.2f", bestFit.value / #sentence)

    table.insert(words, population[bestFit.index])
    if #words > WORDS then
      table.remove(words, 1)
    end
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print("Sentence: " .. sentence, 8, 8)
  love.graphics.print("Generation: " .. generations, 8, 24)
  love.graphics.print("Population size: " .. #population, 8, 40)
  love.graphics.print("Mutation odds: 1 in " .. MUTATION_ODDS, 8, 56)
  love.graphics.print("Fitness ratio: " .. fitnessRatio, 8, 72)

  for i = 1, #words do
    love.graphics.printf(words[#words - i + 1], 0, 8 + 12 * (i - 1), WINDOW_WIDTH - 8, "right")
  end
end
