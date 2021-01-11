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

## 04 - Oscillation

<!-- TODOS
- add reference to replit folder
- fix the code snippet describing the offset for the rectangle. Love2D doesn't support the same syntax used to offset images
  ```lua
  love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
  ```
- comment out the lines drawing the visual debugging circle
 -->

To discuss oscillating motion, it is first necessary to introduce angles, polar coordinates and trigonometry. _Trigonometry_ relates to the study of the angles and sides of right triangles, and is useful to model angles, angular velocity and angular acceleration.

### Angles

To rotate an entity, modify the coordinate system with translations and rotations.

```lua
love.graphics.translate(x, y)
love.graphics.rotate(angle)
--
```

In the snippet, the drawing operations following the two expressions will be rotated by amount described by `angle`.

Love2D, like the Processing library used in the course, works with an angle in _radians_, not degrees. Radians describe the angle in terms of the ratio between the length of the arc of a circle and its radius, with `1` radian being the angle at which the arc has the same length as the radius. To convert between the two, use the following formula:

```lua
radians = 2 * math.pi * (degrees / 360)
```

Alternatively, Lua provides the `math.rad` to convert to radians, `math.deg` to convert to degrees.

It is perhaps useful to note that _pi_ is the ratio between a circle's circumference and its diameter. It is roughly `3.14159` and is provided by Lua in the math library and `math.pi`.

_Please note:_

- in the demo, the script initializes a series of rectangles with varying angles. The `love.graphics` module provides several ways to achieve the same operation, as highlighted by the instruction drawing the rectangle commented out.

  ```lua
  -- love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height, 0, 1, 1, self.width / 2, self.height / 2)
  ```

  The rotation occurs from the point described by the translation, and the two lines modify the offset of the rectangle so that the rotation happens from the center of the shape.

- `.push` and `.pop` are useful to have the translation and rotation affect the single `Mover` entity. Without the instruction, additional shapes would be affected by previous transformations

- `Mover:render()` includes two lines to draw a circle to highlight the coordinate system; consider it a small, visual way to consider how the translation and rotation modify the render logic

### Angular motion

With the same logic described in the update function of the `Mover` entity, modify the angle with a variable describing its velocity and a variable describing its acceleration. The only difference is that the angle is represented by a single variable, and not a vector.

```lua
self.angle = self.angle + self.angularVelocity
self.angularVelocity = self.angularVelocity + self.angularAcceleration
```

To set the acceleration, similarly to the previous examples, use a hard-coded measure or consider the surrounding environment, the forces involved with actual formulas.

_Please note:_

- in the demo the angular acceleration is set at random, but is also and further modified using the `x` coordinate of the mouse cursor. The idea is to have the rectangles rotate in the direction indicated by the mouse

- the angular velocity is limited in order to keep the value in the `(-0.1, 0.1)` range

### Trigonometry

As prefaced at the top of the section, trigonometry relates to the study of the angles and sides of right triangles. In this light, the mnemonic device _sohcahtoa_ is useful to remember the following formulae:

```lua
math.sin(theta) = opposite / hypothenuse
math.cos(theta) = adjacent / hypothenuse
math.tan(theta) = opposite / adjacent
```

To find the angle, the sine, cosine and tangent are used in their inverse form. For instance and knowing the sides of the right triangle, the angle can be computed as:

```lua
theta = math.atan(opposite / adjacent)
```

_Please note:_

- `math.atan` doesn't consider the sign of the sides involved in the formula.

  To fix this, either use a series of `if` statements, for the quadrants in which the sign is the opposite, or `math.atan2`. The function does consider the sign.

  ```lua
  local angle = math.atan(opposite / adjacent)
  local angle = math.atan2(opposite, adjacent)
  ```

  Also note that, in Lua, the function accepts two arguments for the sides of the triangle, instead of one describing the ratio of the two.

- the lines drawing a circle with an `x` offset are useful to show that `math.atan2` works to rotate the shape in the desired direction

  ```lua
  love.graphics.setColor(0.13, 0.86, 0.72)
  love.graphics.circle("fill", self.width / 4, 0, 2)
  ```

  Use `math.tan` and the circle would immediately flip in the opposide end of the rectangle

### Polar coordinats

While Love2D, similarly to the Processing library, renders elements in an `(x, y)` plane, with _cartesian_ coordinates, it is useful to model the simulation in _polar_ coordinates, considering a distance and angle `(r, theta)`.

The trigonometry introduced in the previous section is useful to move from one set to the other.

_Please note:_

- in the demo a `Mover` entity is updated increasing the angle and increasing or decreasing the distance from the center. The polar coordinates are then included in the trigonometric functions cosine and sine in order to position the entity with the cartesian counterpart

### Amplitude and period

_Oscillation_, as the periodic movement between two points, can be defined in terms of _amplitude_ and _period_.

- amplitude: the distance between the center and either of the two points

- period: the time it takes to complete a full cycle

Considering a sine or cosine function, the period is `math.pi * 2`, and the amplitude is `1`.

Starting from the amplitude and period, it is possible to describe _simple harmonic motion_ by updating a variable as follows.

```lua
x = amplitude * math.cos(math.pi * 2 * (frameCount / period))
```

The value returned by `math.cos` doesn't exceed the `(-1, 1)` range, which means the variable is assigned a value in the `(-amplitude, amplitude)` interval. Inside of the parenthesis, dividing the incrementing variable `frameCount` by the period and multiplying the value by `math.pi * 2` means the function completes a cycle as the count reaches the value of the period.

One other feature which defines oscillation is its _frequency_. This value describes the number of cycles per time unit, and is the inverse of the period. If an oscillation has a period of `math.pi * 2`, it completes a cycle in `math.pi * 2`, and has a frequency of `math.pi * 2 / frame`; it covers a certain distance in the span of a single frame.

### Oscillation with angular velocity

Instead of mapping a variable according to amplitude and period, the idea is to consider an incrementing variable in the trigonometric functions for the sine or cosine distribution.

```lua
x = amplitude * math.cos(angle)
```

In this manner the simulation re-introduces the concept of angular velocity, and ultimately angular acceleration.

```lua
angle = angle + angularVelocity
```

It is still possible to define the period, as the amount of time it takes for `angle` to reach `math.pi * 2`.

_Please note:_

- the demo re-introduces vectors to update the angle of the `Oscillator` entity in the `x` and `y` dimension
