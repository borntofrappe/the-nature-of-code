require "Automaton"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
UPDATE_TIMER = 0.15
CELL_SIZE = 10
COLUMNS = math.floor(WINDOW_WIDTH / CELL_SIZE)
ROWS = math.floor(WINDOW_HEIGHT / CELL_SIZE)
LINE_WIDTH = 2

function love.load()
  love.window.setTitle("Cellular automata - Game of life")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  automaton = Automaton:new()
  timer = 0
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local column = math.floor(x / CELL_SIZE) + 1
    local row = math.floor(y / CELL_SIZE) + 1
    automaton:toggle(column, row)
  end

  if button == 2 then
    automaton = Automaton:new()
  end
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
