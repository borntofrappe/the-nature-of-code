require "DNA"
require "Face"
require "Population"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 280
WINDOW_PADDING = 20
WINDOW_UPADTE_SPEED = 20

POPULATION_SIZE = 7
POPULATION_MUTATION_ODDS = 50

ELEMENT_SIZE = 80
ELEMENT_FITNESS_MIN = 1

FACE_SIZE_MIN = 20
FACE_SIZE_MAX = 30

EYES_SIZE_MIN = 4
EYES_SIZE_MAX = 10
EYES_GAP_MIN = 10
EYES_GAP_MAX = 20
EYES_OFFSET_X_MIN = -10
EYES_OFFSET_X_MAX = 10
EYES_OFFSET_Y_MIN = -12
EYES_OFFSET_Y_MAX = -2

MOUTH_WIDTH_MIN = 10
MOUTH_WIDTH_MAX = 20
MOUTH_HEIGHT_MIN = 2
MOUTH_HEIGHT_MAX = 8
MOUTH_OFFSET_X_MIN = -10
MOUTH_OFFSET_X_MAX = 10
MOUTH_OFFSET_Y_MIN = 4
MOUTH_OFFSET_Y_MAX = 12

BUTTON_WIDTH = 200
BUTTON_HEIGHT = 40
BUTTON_LINE_WIDTH = 4

function love.load()
  love.window.setTitle("The evolution of code - Interactive selection")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  population = Population:new(POPULATION_SIZE, POPULATION_MUTATION_ODDS)
  button = {
    ["text"] = string.upper("Generate"),
    ["x"] = WINDOW_WIDTH / 2 - BUTTON_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT - WINDOW_PADDING - BUTTON_HEIGHT,
    ["width"] = BUTTON_WIDTH,
    ["height"] = BUTTON_HEIGHT
  }
end

function love.mousepressed(x, y, btn)
  if btn == 1 then
    if x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height then
      population:generate()
    end
  end
end

function love.update(dt)
  population:update(dt)
end

function love.draw()
  population:render()

  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(BUTTON_LINE_WIDTH)
  love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
  love.graphics.printf(button.text, button.x, button.y + button.height / 2 - 8, button.width, "center")
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
