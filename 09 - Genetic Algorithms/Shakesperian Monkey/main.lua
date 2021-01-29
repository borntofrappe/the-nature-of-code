WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
UPDATE_TIMER = 0.1
WORDS = 40

function love.load()
  love.window.setTitle("Genetic algorithms - Shakesperian monkey")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  sentence = "hell"
  words = {}

  timer = 0
  foundIt = false
end

function getRandomCharacter()
  local start = string.byte("a")
  local finish = string.byte("z")
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
    timer = timer + dt
    if timer > UPDATE_TIMER then
      timer = timer % UPDATE_TIMER
      local word = getRandomWord(#sentence)
      table.insert(words, word)

      if #words > WORDS then
        table.remove(words, 1)
      end

      if word == sentence then
        foundIt = true
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(sentence, 8, 8)
  for i = 1, #words do
    love.graphics.print(words[#words - i + 1], 8, 24 + 12 * (i - 1))
  end
end
