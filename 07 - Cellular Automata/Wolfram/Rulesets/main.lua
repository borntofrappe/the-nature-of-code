require "Automaton"

WINDOW_WIDTH = 510
WINDOW_HEIGHT = 510
UPDATE_TIMER = 0.05
CELL_SIZE = 5
NEIGHBORS = math.floor(WINDOW_WIDTH / CELL_SIZE)
LINE_WIDTH = 2
MAX_RULE = 255

function love.load()
  love.window.setTitle("Cellular automata - Wolfram - Rulesets")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  automaton = Automaton:new()
  timer = 0
end

function love.update(dt)
  timer = timer + dt
  if timer > UPDATE_TIMER then
    timer = timer % UPDATE_TIMER
    automaton:update()
    if automaton.hasExpired then
      automaton = Automaton:new()
    end
  end
end

function love.draw()
  love.graphics.print("Rule " .. automaton.rule, 2, WINDOW_HEIGHT - 14)
  automaton:render()
end

function binaryToDecimal(binary)
  local decimal = 0
  local binaryString = tostring(binary):reverse()
  for i = 1, #binaryString do
    local binaryDigit = math.floor(binaryString:sub(i, i))
    decimal = decimal + math.floor(binaryDigit * 2 ^ (i - 1))
  end
  return decimal
end

function decimalToBinary(decimal, length)
  local binary = decimal == 0 and "0" or ""

  while decimal / 2 > 0 do
    local integerQuotient = math.floor(decimal / 2)
    local remainder = decimal % 2
    binary = remainder .. binary
    decimal = integerQuotient
  end

  if length then
    return string.format("%0" .. length .. "d", binary)
  end

  return binary
end
