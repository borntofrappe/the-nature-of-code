require "Automaton"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
UPDATE_TIMER = 1
CELL_SIZE = 25
NEIGHBORS = math.floor(WINDOW_WIDTH / CELL_SIZE)
LINE_WIDTH = 2

function love.load()
  love.window.setTitle("Cellular automata - Cellular automaton")
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
  end
end

function love.draw()
  automaton:render()
end
