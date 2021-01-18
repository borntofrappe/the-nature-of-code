WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
METER = 100
RADIUS_MIN = 4
RADIUS_MAX = 8
RADIUS_ATTRACTOR = 20
PARTICLES = 20
RESTITUTION = 0.25
GRAVITATIONAL_FORCE = 5
REPULSION_FORCE = 200
VELOCITY_MIN = 40
VELOCITY_MAX = 160
DISTANCE_MIN = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 4)
DISTANCE_MAX = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 2)

require "Circle"

function beginContact(f1, f2)
  local userdata1 = f1:getUserData()
  local userdata2 = f2:getUserData()
  local userdata = {}
  userdata[userdata1] = true
  userdata[userdata2] = true

  if userdata["attractor"] then
    local particle = userdata1 == "attractor" and particles[userdata2] or particles[userdata1]
    local fx, fy = attractor:repel(particle)
    particle:applyForce(fx, fy)
  end
end

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Collision events")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, 0)
  world:setCallbacks(beginContact)

  particles = {}
  for i = 1, PARTICLES do
    local userdata = "particle" .. i
    local angle = math.rad(math.random(360))
    local distance = math.random(DISTANCE_MIN, DISTANCE_MAX)
    local x = WINDOW_WIDTH / 2 + math.cos(angle) * distance
    local y = WINDOW_HEIGHT / 2 + math.sin(angle) * distance
    local r = math.random(RADIUS_MIN, RADIUS_MAX)

    particle = Circle:new(world, x, y, r, "dynamic", userdata)
    particle.fixture:setRestitution(RESTITUTION)
    local vx = math.random(VELOCITY_MIN, VELOCITY_MAX)
    local vy = math.random(VELOCITY_MIN, VELOCITY_MAX)
    if math.random() > 0.5 then
      vx = vx * -1
    end
    if math.random() > 0.5 then
      vy = vy * -1
    end
    particle.body:setLinearVelocity(vx, vy)
    particles[userdata] = particle
  end

  attractor = Circle:new(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, RADIUS_ATTRACTOR, "kinematic", "attractor")
end

function love.update(dt)
  world:update(dt)

  for k, particle in pairs(particles) do
    local fx, fy = attractor:attract(particle)
    particle:applyForce(fx, fy)
  end

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    local ax = attractor.body:getX()
    local ay = attractor.body:getY()
    local dx = x - ax
    local dy = y - ay
    attractor.body:setLinearVelocity(dx, dy)
  end
end

function love.draw()
  for k, particle in pairs(particles) do
    particle:render()
  end

  attractor:render()
end
