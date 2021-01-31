WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
-- maximum number of words stored in the _words_ collection
WORDS = 40

START = "a"
FINISH = "z"
SENTENCE = "hello"

function love.load()
  love.window.setTitle("Genetic algorithms - Shakesperian monkey")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  sentence = SENTENCE
  generations = 0
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

function love.update(dt)
  if not foundIt then
    local word = getRandomWord(#sentence)
    table.insert(words, word)

    generations = generations + 1

    if #words > WORDS then
      table.remove(words, 1)
    end

    if word == sentence then
      foundIt = true
    end
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print("Sentence: " .. sentence, 8, 8)
  love.graphics.print("Generation: " .. generations, 8, 24)
  for i = 1, #words do
    love.graphics.printf(words[#words - i + 1], 0, 8 + 12 * (i - 1), WINDOW_WIDTH - 8, "right")
  end
end
