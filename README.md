[_The Nature of Code_](https://natureofcode.com/book/) introduces many concepts to simulate real-world phenomena with code. Here, I follow the book to learn about these concepts.

The notes which follow are my own. The demos are written in [Lua](https://www.lua.org/) and [Love2D](https://love2d.org/).

[![the-nature-of-code repository](https://github.com/borntofrappe/the-nature-of-code/blob/master/banner.svg)](https://github.com/borntofrappe/the-nature-of-code)

## Useful Links

- [_The Nature of Code_ book](https://natureofcode.com/book/)

- [_The Nature of Code_ playlist](https://www.youtube.com/c/TheCodingTrain/playlists?view=50&shelf_id=9) on [The Coding Train YouTube channel](https://www.youtube.com/c/TheCodingTrain)

- [Project folder on repl.it](https://repl.it/repls/folder/the-nature-of-code)

## [01 - Randomness](https://repl.it/repls/folder/the-nature-of-code/01%20-%20Randomness)

Randomness provides a first, rudimentary way to simulate real phenomena.

### Random

A random function returns a number in a range with the same probability as any number in the same range. The output isn't truly random, but pseudo-random, whereby the function creates a series of numbers and returns one of them. The sequence repeats itself, but over a long stretch of time.

To move an entity at random, there exist several strategies:

- with `math.random(4)` and a chain of `if` statements, move the entity in one of the four cardinal directions

- with `math.random(3)`, modify the coordinates to have the entity move or stand still

- with `math.random()`, modify the coordinates with a floating point number

_Please note:_

- Lua is 1-indexed. In light of this, `math.random(4)` returns a number in the `[1,4]`, and `math.random(3)` returns a number in the `[1,3]` range

- `math.random()` returns the same sequence of random numbers unless you first set a random seed

  ```lua
  function love.load()
    math.randomseed(os.time())
  end
  ```

  It is possible to use `love.math.random`, a function which is automatically seeded by Love2D, but I chose the non-seeded version to stress how the function is not truly random.

### Probability

The probability of a single event is given by the number of outcomes representing the event divided by the number of possible outcomes. The probability of multiple events occurring in sequence is obtained by multiplying the single events. The concept is useful to describe the random functions, but also the distribution of other functions.

With the random function, you can obtain a certain probability with at least two methods:

- initialize a bucket, a container with a set of options and pick at random from the set

- ask for a random number in the `(0, 1)` range and use the value to execute an option with the given probability

_Please note:_

- the method using probabilities computes the _cumulative_ probability of each option. In the code, the for loop is a convenience alternative to a series of `if` statements

  ```lua
  if random < 0.5
  elseif random < 0.55
  elseif random < 0.85
  elseif random < 1
  end
  ```

### Normal distribution

A normal, or Gaussian, distribution returns a number starting from two values: a mean and a standard variation. The idea of the distribution is that numbers are more likely to approach the mean than deviate from it. How often the numbers distance themselves from the mean is described by the standard deviation. With a small deviation, the numbers gather around the mean. Opposedly, and with a large deviation, the numbers scatter away from the central value.

For the normal distribution, it is useful to remember the following:

- given a population and a normal distribution, 68% of the observations fall in the range of the standard deviation, 98% in the range of twice the standard deviation and 99.7% in the range of thrice the same value. This is often described as the [_68,98,99.7 Rule_](https://en.wikipedia.org/wiki/68%E2%80%9395%E2%80%9399.7_rule)

- to compute the standard deviation with a mean and a set of observations, consider the value of each observation, subtract the mean and square the result. Sum this measure for all observations to gather the _variance_. The standard deviation is the square root of the variance.

- a function `f(x)` returns a number `y` in a normal distribution with mean `mu` and standard deviation `sigma` with the following formula

  ```lua
  f(x) = 1 / (sigma * (2 * math.pi) ^ 0.5) * e ^ (- 1 / 2 * ((x - mu) / sigma) ^ 2)
  ```

  `e` describes [_Euler's number_](<https://en.wikipedia.org/wiki/E_(mathematical_constant)>), and is approximated to `2.71828`.

- the tallest point of the bell curve depends on the standard deviation, and is computed with the following formula

  ```lua
  y = 1 / ((2 * math.pi) ^ 0.5 * sigma)
  ```

_Please note:_

- in the demo the normal function is used to generate an assortment of numbers with mean `0` and standard deviation `1`. These values are then used to draw a line, describing the associated bell curve, and move the `Mover` entity

- the demo introduces a mapping function similar to the method detailed in the [processing library](https://github.com/processing/p5.js/blob/main/src/math/calculation.js#L450)

### Custom distribution

To fit the needs of a simulation, you can customize a distribution in several ways. The `Probability` folder already introduces two possibilities, with the methods picking a number from a given set, or using the cumulative probability. Here, a custom distribution is built with the following algorithm:

- pick a random value

- assign a probability to the value

- pick a second random value

- if the second random value is less than the probability, accept the first pick

- else, repeat the process

This approach means that values with a greater probability are more likely to be accepted. The custom nature of the distribution comes from the way the probability is then computed.

It helps to consider the probability as the `y` value for a function in an `(x, y)` plane. When the probability is equal to the random value, as in the demo, the relationship is linear. When the probability is instead equal to the value squared, the relationship is squared.

_Please note:_

- in the demo, the value is picked in the `(0, 1)` range, with a tendency for higher numbers. The value is finally updated to change the direction at random.

  ```lua
  if math.random() > 0.5 then
    x = x * -1
  end
  -- repeat for the `y` coordinate
  ```

  This is to avoid having the `Mover` entity move outside of the window too rapidly.

### Perlin noise

The Perlin noise function allows to create a sequence of numbers connected to each other, with the goal of providing smooth random values. You pick numbers from the sequence, and the distance between the numbers dictates the difference between the two. The greater the distance, the more likely the numbers will differ. The smaller the offset, the more likely the numbers will resemble one another.

While it is possible to create a function implementing the logic of Perlin noise, Love2D provides a similar functionality in `love.math.noise`.

The function returns a sequence of numbers in the `(0,1)` range and accepts multiple arguments, to create noise in multiple dimensions. In one dimension, each number is related to the one coming before and after it. In two, it is connected to the numbers representing the possible neighbors in the `(x,y)` plane. In three, the neighbors considering a third dimension `(z)` as well.

_Please note:_

- the demo works similarly to `Normal distribution`, by plotting the numbers with a line and update the `Mover` entity to follow the line's coordinates

- using the same offset returns the same noise value. This explains why the for loop begins at an arbitrary offset, chosen at random

  ```lua
  local offset = math.random(OFFSET_INITIAL_MAX)
  for i = offset -- continues -- do

  end
  ```

- `OFFSET_INCREMENT` describes the distance between successive points.

  ```lua
  OFFSET_INCREMENT = 0.02
  ```

  The smaller the value, the smoother the line.

- `getNoiseNumbers` creates a series of numbers to plot the line and update the `Mover` entity. `getNoiseBackground` instead produces a grid of numbers to color the background with a makeshift texture; this last function is used to showcase how `love.math.noise` works with two arguments and dimensions

## [02 - Vectors](https://repl.it/repls/folder/the-nature-of-code/02%20-%20Vectors)

Vectors as introduced in the book are _euclidean_ vectors, entities with a _magnitude_ and a _direction_. They are introduced in the context of a plane with two dimensions, `x` and `y`, but fundamentally, they work in the same manner with additional dimensions.

Think of a vector with two components as an arrow. The length of the arrow describe its magnitude, while the angle relative to an axis its direction. A vector describing the position of a particle details where to position the object from the origin. A vector describing the velocity dictates where to move the same particle.

_Please note:_

- `Vector.lua` is used to introduce the vector entity with a table

- the demo in the `Vector` folder shows two vectors, a position vector centering a circle in the middle of the screen, and a velocity vector radiating from the starting point. The velocity vector is finally updated using the coordinates of the mouse cursor

### Vector math

Vectors follow specific rules to compute mathematical operations.

- add vectors by considering the sum of the respective components

- subtract vectors by decreasing the components of the first vector with the components of the second

- multiply a vector with a scalar by multiplying each component with the same measure; this operation is useful to scale the vector

- divide by a scalar by dividing each component; be sure that the scalar is different from 0

- compute the vector's magnitude; using pythagorean theorem, `a^2 + b^2 = c^2`, the magnitude represents the length, the distance between two points considering the `x` and `y` component: `m = (vector.x^2 + vector.y^2)^2`

- normalize a vector by dividing the vector by its magnitud. With this operation, you obtain a vector with length 1, a _unit vector_; the operation is helpful to have a unit vector with the same direction as the first vector. From this point you can scale the vector to any arbitrary length, by further multiplying the unit vector with the desired magnitude

- limit a vector to a given magnitude; the idea is to here compute the magnitude, and if greater than the input value proceed to scale down the vector to said magnitude. In practice, this operation is achieved by normalizing the vector and scaling the same entity with the input magnitude

_Please note:_

- `Vector.lua` is updated to compute different mathematical operations on the vector itself. Be careful that these methods (add, subtract, multiply and divide) modify the original entity

- `LVector.lua` is introduced as a rudimentary version of the Processing library, and defines several methods to compute roughly the same mathematical operations. The key difference is that the methods do not modify the input vector(s), but return a new entity altogether

### Velocity

With two vectors describing the position and velocity, it is possible to move an object at a constant rate.

_Please note:_

- in the demo, the location is updated with the vector describing the velocity. The velocity is however and first scaled to consider `dt`, delta time.

  ```lua
  self.position:add(LVector:multiply(self.velocity, dt))
  ```

  This is specific to the engine Love2D, and allows to move the particles irrespective of the frame rate

### Acceleration

With three vectors, it is possible to move an object with an accelerated rate, speeding up or slowing down. The idea is to update the position with the velocity, and the velocity with the acceleration.

```lua
self.position:add(self.velocity)
self.velocity:add(self.acceleration)
```

With this setup, the goal of the simulation is to then set a particular acceleration. This value can be set arbitrarily, as with a constant or random value, or following actual physics, as with of gravity or wind strength.

_Please note:_

- in the `Acceleration` folder you find two demos: `Constant` setting a positive or negative acceleration with a particular key press, and `Mouse`, updating the acceleration to have the entities move toward the mouse cursor

## [03 - Forces](https://repl.it/repls/folder/the-nature-of-code/03%20-%20Forces)

The goal is to adapt the concept of forces and Newtonian physics to the simplified environment introduced with vectors.

### Newton's laws

In the simplified environment, a force is described as a vector which causes an object with mass to accelerate.

Newton's first law, arguing that an object at rest stays at rest and an object in motion stays in motion, is adapted by saying that the vector describing the velocity stays constant. The only way for an object to stop, to reach an equilibrium is for the velocity to be affected by a series of forces which cancel its magnitude.

Newton's third law, detailing an action/reaction pair for any force, is partly incorporated in the environment by occasionally including a force contrasting the original one.

Newton's second law, providing a formula to compute a force on the basis of mass and acceleration, is finally essential to the simulation. This law states that the force is equal to mass times acceleration.

```lua
->      ->
F = m * a
```

In a first approximation, and assuming a mass equal to 1, an immediate way to apply the force is to therefore set the acceleration to the force itself

```lua
function Mover:applyForce(force)
  self.acceleration = force
end
```

_Please note:_

- in the demo for the `Newton's law` folder a `Mover` entity is initialized without velocity, nor acceleration. The acceleration vector is then modified in `love.load` by applying a force

  ```lua
  local force = LVector:new(fx, fy)
  mover:applyForce(force)
  ```

### Force accumulation

The previous solution works, but only when a single force is applied. With multiple forces, only the last one is incorporated in the acceleration vector. The implementation is therefore modified to consider the effect of a force as cumulative (force accumulation)

```lua
function Mover:applyForce(force)
  self.acceleration:add(force)
end
```

Be careful that it is necessary to reset the acceleration vector. In this manner, the object considers the forces available in the specific frame, and not every force accumulated in the simulation.

```lua
self.acceleration:multiply(0)
```

_Please note:_

- in the demo the `Mover` entity is updated to move downwards as subject to a force of gravity. When the mouse is pressed then, another force is applied to move the object horizontally as well

  ```lua
  local gravity = LVector:new(0, GRAVITY)
  mover:applyForce(gravity)

  if love.mouse.isDown(1) then
    local wind = LVector:new(WIND, 0)
    mover:applyForce(wind)
  end
  ```

### Mass

In a slightly more elaborated construct, a force is weighed by the object mass.

```lua
function Mover:applyForce(force)
  self.acceleration:add(LVector:divide(force, self.mass))
end
```

It is important to note, however, that forces like gravity already incorporate the mass in their value. For these forces, it is necessary to remove the mass's influence.

```lua
local gravity = LVector:new(0, GRAVITY)
mover:applyForce(LVector:multiply(gravity, mover.mass))
```

_Please note:_

- in the demo `love.load` initializes a series of `Mover` entities with a random mass. The mass is also used to change the radius of the circle

- `LVector:divide(force, self.mass)` is used in place of `force:divide(self.mass)` to avoid modifying the input force. In the specific demo this precaution is however not necessary, as the force is computed every frame

### Creating forces

In a simulation, create a force with an arbitrary value, or following the guidance of an actual formula. In this last instance, the simulation needs to compute the magnitude and direction of the force vector from a given set of values.

#### Friction

Friction is applied on a moving object to progressively reduce its velocity. The actual formula computes the vector by considering the unit vector describing the velocity, a coefficient of friction (`mu`), and the magnitude of the normal force.

```lua
->                       ^
F = -1 * mu * ||N|| * velocity
```

In a first approximation, it is possible to simplify the force by considering its direction and magnitude. In terms of direction, friction has a direction opposite to the velocity vector. Notice how the unit vector is multiplied by `-1`.

```lua
->          ^
F = -1 * velocity
```

In terms of magnitude, the force is scaled with a constant value.

```lua
->          ^
F = -1 * velocity * c
```

A more elaborate simulation would try to compute the normal vector, and its eventual magnitude, would incorporate the coefficient according to the surface creating the friction, or again the normal force and its magnitude, but in the approximation, it is enough to scale the vector with a constant. By changing the constant, the simulation is able to then describe a surface with higher/smaller friction.

_Please note:_

- the `Mover` entity is simplified to have a mass of `1` and move only horizontally

- the demo is simplified to only show the force of friction. There is no gravity, nor wind, but a force increasing the velocity when the mouse is being pressed

- `LVector` is updated to include a method which returns a copy of the input vector. The function is useful to normalize a copy of the velocity vector, without modifying the original velocity

#### Drag

A force of drag considers the density of the material through which the object is moving, `rho`, the magnitude of the object's velocity, `||v||`, the surface area subject to resistance `A`, a coefficient of drag `C` and the velocity's unit vector `^v`

```lua
->                                      ^
F = -1 / 2 * rho * ||v||^2 * A * C * velocity
```

Similarly to the `Friction` demo, however, the force can be simplified by considering direction and magnitude. For the direction, the force is again the opposite of the velocity vector.

```lua
->              ^
F = -1 / 2 * velocity
```

For the magnitude, the force is scaled according to the magnitude of the velocity, and a value summarising the other constants.

```lua
->          ^
F = -1 * velocity * ||v||^2 * c
```

_Please note:_

- the demo is updated to consider multiple entities with varying mass, as in the `Mass` demo. Notice how objects with a greater mass are subject to less drag, since the force is divided by the mass measure

- each `Mover` entity is subject to different drag forces and according to the entity's own position. In the bottom half of the screen, the script simulates a more dense environment with a greater coefficient

#### Gravitational attraction

The force of gravity depends on the mass of the objects involved, `m1` and `m2`, the distance between said objects `d`, as well as a constant describing the gravitational force `G`. In terms of direction, the force finally depends on the direction of the vector connecting the two objects, `^r`.

```lua
->                            ^
F = G * ((m1 * m2) / d ^ 2) * r
```

The unit vector connecting the objects describes the direction of ths force.

```lua
->                            ^
F = G * ((m1 * m2) / d ^ 2) * r
```

The constant, mass values and then distance finally influence the magnitude of the force.

```lua
F = G / (d ^ 2)
```

_Please note:_

- the attraction force is computed in a method of an `Attractor` entity

- in the `Gravitational attraction` folder you find three demos

  1. with `Simple` the idea is to update a `Mover` entity toward a fixed `Attractor` considering only the gravitational constant and the distance between the two objects

  2. in `Complex` the simulation contemplates multiple `Mover` entities with varying mass. The demo has also a minor interaction in the form of the `pullIn` method; following a mouse click, the idea is to have the entities move rapidly toward the attractor

  3. in `Mouse` the `Mover` entities gravitate toward the mouse cursor, and away from other entities
