[_The Nature of Code_](https://natureofcode.com/book/) introduces many concepts to simulate real-world phenomena with code. Here, I follow the book to learn about these concepts.

The notes which follow are my own. The demos are written in [Lua](https://www.lua.org/) and [Love2D](https://love2d.org/).

[![the-nature-of-code repository](https://github.com/borntofrappe/the-nature-of-code/blob/master/banner.svg)](https://github.com/borntofrappe/the-nature-of-code)

## Useful Links

- [_The Nature of Code_ book](https://natureofcode.com/book/)

- [_The Nature of Code_ playlist](https://www.youtube.com/c/TheCodingTrain/playlists?view=50&shelf_id=9) on [The Coding Train YouTube channel](https://www.youtube.com/c/TheCodingTrain)

- [Project folder on repl.it](https://repl.it/repls/folder/the-nature-of-code)

## 00 - Randomness

Randomness provides a first, rudimentary way to simulate real phenomena.

### Random

A random function returns a number in a range with the same probability as any number in the same range. The output isn"t truly random, but pseudo-random, whereby the function creates a series of numbers and returns one of them. The sequence repeats itself, but over a long stretch of time.

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

  `e` describes [_Euler"s number_](<https://en.wikipedia.org/wiki/E_(mathematical_constant)>), and is approximated to `2.71828`.

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

- the demo works similarly to `Normal distribution`, by plotting the numbers with a line and update the `Mover` entity to follow the line"s coordinates

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

## 01 - Vectors

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

- compute the vector"s magnitude; using pythagorean theorem, `a^2 + b^2 = c^2`, the magnitude represents the length, the distance between two points considering the `x` and `y` component: `m = (vector.x^2 + vector.y^2)^2`

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

## 02 - Forces

The goal is to adapt the concept of forces and Newtonian physics to the simplified environment introduced with vectors.

### Newton"s laws

In the simplified environment, a force is described as a vector which causes an object with mass to accelerate.

Newton"s first law, arguing that an object at rest stays at rest and an object in motion stays in motion, is adapted by saying that the vector describing the velocity stays constant. The only way for an object to stop, to reach an equilibrium is for the velocity to be affected by a series of forces which cancel its magnitude.

Newton"s third law, detailing an action/reaction pair for any force, is partly incorporated in the environment by occasionally including a force contrasting the original one.

Newton"s second law, providing a formula to compute a force on the basis of mass and acceleration, is finally essential to the simulation. This law states that the force is equal to mass times acceleration.

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

- in the demo for the `Newton"s law` folder a `Mover` entity is initialized without velocity, nor acceleration. The acceleration vector is then modified in `love.load` by applying a force

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

It is important to note, however, that forces like gravity already incorporate the mass in their value. For these forces, it is necessary to remove the mass"s influence.

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

A force of drag considers the density of the material through which the object is moving, `rho`, the magnitude of the object"s velocity, `||v||`, the surface area subject to resistance `A`, a coefficient of drag `C` and the velocity"s unit vector `^v`

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

- each `Mover` entity is subject to different drag forces and according to the entity"s own position. In the bottom half of the screen, the script simulates a more dense environment with a greater coefficient

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

## 03 - Oscillation

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

It is perhaps useful to note that _pi_ is the ratio between a circle"s circumference and its diameter. It is roughly `3.14159` and is provided by Lua in the math library and `math.pi`.

_Please note:_

- in the demo, the script initializes a series of rectangles with varying angles. To rotate the shapes from the center, the `x` and `y` coordinate offset the shape by half its width and height.

  ```lua
  love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
  ```

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

- `math.atan` doesn"t consider the sign of the sides involved in the formula.

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

The value returned by `math.cos` doesn"t exceed the `(-1, 1)` range, which means the variable is assigned a value in the `(-amplitude, amplitude)` interval. Inside of the parenthesis, dividing the incrementing variable `frameCount` by the period and multiplying the value by `math.pi * 2` means the function completes a cycle as the count reaches the value of the period.

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

### Applying trigonometry

With the knowledge accumulated in the chapter, and the chapters before it, the goal is to here apply the concepts in practical simulations.

### Waves

In order to create a wave, all that is necessary is to increment the angle for every entity, assigning the horizontal coordinate to a fraction of the total width and the vertical coordinate to the sine or cosine of the angle. The amplitude remains relevant, in describing the height of the line.

_Please note:_

- with `getPoints()`, the script produces an horizontal coordinate `x`, but also two coordinates for the `y` dimension, `y1` and `y2`. The idea is to use the opposite value returned by the cosine function to create a pattern inspired by a DNA sequence

- with `love.update()`, the initial angle modifying the `y` coordinates of the points is incremented by an arbitrary value. The idea is to simulate the ondulating movement of a wave

- with `CYCLES`, the script provides a way to include a shorter period (or higher frequency). The angular velocity is nevertheless scaled according to `math.pi * 2` to ensure that the first and last point have the same angle

### Pendulum

In the simulation, a pendulum is composed of a pivot, an arm and a bob.

```text
 x  <-- pivot
  \
   \  <-- arm
    \
     o  <-- bob
```

The idea is to have the pivot function as the point around which the bob rotates, at a distance given by the inflexible arm.

With this structure, the pendulum is subject to a force of gravity, pulling the bob downwards. The fact that the bob is attached to the immovable pivot, however, means that the force of gravity doesn"t affect the round shape only in its `y` dimension.

```text
 x
  \
   \
    \
     o
  ->/ |
  F/  |
  /90°|
  \   |
   \  |
    \a|
     \| gravity
```

Considering a right triangle whose hypothenuse describes the force of gravity, it is possible to decompose the vertical force in two different segments, and find the force `F` according to the angle `a` and the trigonometric functions introduced in the previous sections.

```text
     x
     |a\
     |  \
     |   \
          o
opposite/ |
       /  |
      /   |
      \   | hypothenuse
       \  |
        \a|
         \|
```

The angle is updated with the same logic introduced in the force chapter.

```lua
self.angle = self.angle + self.angularVelocity * dt * UPDATE_SPEED
self.angularVelocity = self.angularVelocity + self.angularAcceleration * dt * UPDATE_SPEED
```

Instead of a vector, here is the angle to be updated by the velocity, and the velocity by the acceleration.

Velocity and acceleration are initialized to `0`. The acceleration value is then set with the trigonometric functions prefaced in this very chapter. The relevant function is the sine function, knowing the angle and the hypothenuse, and realizing the opposite segment describes the desired force (remember the _soh_ in _sohcahtoa_).

```lua
self.angularAcceleration = math.sin(self.angle) * GRAVITY * dt * -1
```

The value is multiplied by `-1` since in Love2D, the coordinate system works left to right, top to bottom.

To create a more realistic simulation, the acceleration is also scaled according to the length of the arm.

```lua
self.angularAcceleration = math.sin(self.angle) * GRAVITY / ARM_LENGTH * dt * -1
```

Finally, and to have the pendulum slowly reduce its oscillation, the angular velocity is multiplied by a value slightly smaller than `1`.

```lua
self.angularVelocity = self.angularVelocity * 0.995
```

_Please note:_

- the demo introduces multiple instances of the `Pendulum` entity create a grid of pendulums. Beside the different coordinates for the pivot, each successive instance is given a slightly different starting angle

- following a mouse press, the demo increases the angular velocity to have the pendulums resume their oscillation

### Spring

Instead of an inflexible arm, like the one introduced with the simulation of the pendulum, the idea is to have an elastic arm. Instead of using trigonometric functions to then describe the position of the bob and the length of the arm, the idea is to consider the force applied by the spring. In this manner, the influence of the spring can be paired with other forces, like gravity or wind.

Starting with Hooke"s law, the force applied by a spring is directly proportional to the extension of the spring. The farther the bob stretches the spring from its rest length, the greater the force.

```lua
->       ->
F = -k * x
```

`k` describes a constant to describe how elastic is the spring. It scales the vector describing the displacement to have a stronger or weaker force.

`x` describes the displacement from the spring"s rest length.

A spring tends to a state of equilibrium, described by the rest length. As the bob stretches the arm, the displacement causes an opposite force toward the original length.

```text
    x
    |
    |
    | restLength
    |
  ->|
  F | currentLength
    o
```

Coming back to the formula, and with the logic introduced in the force chapter, it is necessary to evaluate the force"s magnitude and direction. In terms of magnitude, it is possible to directly use the constant `k`. In terms of direction, the vector `x` is obtained by comparing the current length of the arm against the rest length.

In code, the idea is to ultimately apply the force similarly to the force of gravity introduced in earlier demos.

```lua
bob:applyForce(spring)
```

The vector describing the force is then calculated as follows:

- find the vector describing the difference between the bob"s position and the spring"s anchor

  ```lua
  local direction = LVector:subtract(bob.position, self.anchor)
  ```

  The magnitude of this vector provides the current length, to be compared against the rest length; the unit vector provides instead the direction at which to point the force.

- compute the displacement, `x`, as the difference between current and rest length

  ```lua
  local currentLength = direction:getMagnitude()
  local displacement = currentLength - self.restLength
  ```

- normalize the vector and describe the force as the vector, scaled by the Hooke"s formula

  ```lua
  direction:normalize()
  local spring = LVector:multiply(direction, K * -1 * displacement)
  ```

## 04 - Particle System

Starting from a single particle, the idea is to manage multiple entities, in concert. A system is useful to simulate complex phenomena, like fire, smoke, flocks of birds.

### Particle

Picking up from the logic introduced with the `Mover` entity in the forces chapter, a single particle is built with three vectors: position, velocity and acceleration. The idea is to update the position with the velocity, and the velocity with the acceleration.

```lua
this = {
  ["position"] = position,
  ["velocity"] = velocity,
  ["acceleration"] = acceleration,
}
```

On top of these vectors, each particle is attributed a `lifespan`. This value is useful to determine when a particle dies off. In the context of a particle system, there is usually an _emitter_, producing particles or a stream of particles; as new and new particles are created, it is necessary to remove existing ones.

```lua
this = {
  ["lifespan"] = 1
}
```

In a first implementation, the lifespan is connected to the alpha channel of the particle, and decreased with every iteration.

```lua
function Particle:update(dt)
  self.lifespan = self.lifespan - dt * UPDATE_SPEED
end

function Particle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  -- draw circle
end
```

An additional method on the `Particle` entity finally describes whether the particle is dead or not, by returning `true` or `false` on the basis of the lifespan value.

````lua
function Particle:isDead()
  return self.lifespan == 0
end```
````

_Please note_:

- the alpha channel in Love2D is in the `(0, 1)` range

- `lifespan` is decreased to reach the minimum value of `0`. This by using `math.max` and provide a lower threshold.

  ```lua
  function Particle:update(dt)
    self.lifespan = math.max(0, self.lifespan - dt * UPDATE_SPEED)
  end
  ```

### Particles

From a single particle, the idea is to produce a new entity with every iteration of the `love.update` function, and remove particles when they eventually die; this last part is implemented with the `:isDead` method.

When removing a particle inside of a loop considering the collection, it is important to note that the collection is updated by translating the items to the left. Iterating through the table in order, the risk is to therefore skip a particle. One immediate way to fix this is to loop through the collection backwards.

```lua
for i = #particles, 1, -1 do
  particles[i]:update(dt)
  if particles[i]:isDead() then
    table.remove(particles, i)
  end
end
```

_Please note_:

- in `love.draw` the `love.graphics.print` function is used to double check that the particles are removed from the collection. Remove the comment to see how the table has at most roughly `239` items

### Particle system

The collection of particles is stored and managed in a `ParticleSystem` entity. The system is initialized with an `x` and `y` coordinate, to spawn particles from a specific point of origin.

_Please note:_:

- in the demo, the origin of the particle system is modified following the mouse cursor

### Particle systems

Building on top of a particle system as a collection of particles, it is possible to build a collection of collections, of particle systems. This is beyond the scope of the chapter, but useful to describe a simulation in multiple layers of complexity.

_Please note_:

- in the demo, the script initializes a particle system following a mouse click, and removes a collection when there are no more particles

- always in the demo, and in order to eventually remove particle systems, the rate at which particles are produced is decreased with delta time. The rate at which the particles become fully transparent is also increased

### Inheritance and polymorphism

In the scope of object oriented programming, inheritance is useful to create a system in which entities pick up and expand the logic introduced by other entities. Case in point, `SquareParticle` and `CircleParticle` can inherit the behavior of the `Particle` entity, and render the particle with a different shape, respectively, a square and a circle.

Polymorphism, as introduced in the book, refers to how it is possible to have different classes like `Dog` and `Cat` are able to retain multiple types, multiple forms. A `Dog` class inheriting from an `Animal` class is therefore both a dog and an animal. This is useful to have a collection like an array or array list with a singular type, storing different types of animals and call the same function on every instance. What the function does, then, depends on the implementation in the different classes.

_Please note:_

- the logic necessary to implement inheritance depends on the language being used. In the context of lua, there is no class system, but it is possible to recreate a mechanism similar to a prototype and have a table refer to a parent table (a concept similar to a superclass)

- in Lua, a dynamically typed language with no concept of a class system, polymorphism is not a concern. A table stores different entities, without concern for their type

### Forces

The idea is to re-introduce the concepts of earlier chapters, but in the context of a particle system. The section is also useful to describe the structure of the simulation, and how certain methods are defined on the system, as a whole, and other methods on the particles, individually.

#### Apply force

One immediate way to influence the particle system is by applying a force to each and every particle. The logic is structured in two steps:

- apply a force on the system

  ```lua
  local gravity = LVector:new(0, GRAVITY)
  particleSystem:applyForce(gravity)
  particleSystem:applyRepeller(repeller)
  ```

- apply the force on the composing particles

  ```lua
  function ParticleSystem:applyForce(force)
    for i, particle in ipairs(self.particles) do
      particle:applyForce(force)
    end
  end
  ```

The function is defined on the `Particle` entity, similar to `Mover` in the dedicated chapter.

```lua
function Particle:applyForce(force)
  self.acceleration:add(LVector:divide(force, self.mass))
end
```

_Please note_:

- out of convenience, the particles are attributed a mass equal to `1`

#### Repel

Another way to affect the particles in the particle system is to create a separate structure, like a `Repeller` entity.

In `love.update(dt)`, the system receives the repeller as an argument.

```lua
function love.update(dt)
  particleSystem:applyRepeller(repeller)
end
```

The dedicated function, then, loops through the set of particles to create the appropriate force of each entity.

```lua
function ParticleSystem:applyRepeller(repeller)
  for i, particle in ipairs(self.particles) do
    local force = repeller:repel(particle)
    particle:applyForce(force)
  end
end
```

_Please note:_

- to compute the force, the `repel` function considers the method developed for the _Gravitational attraction_ demo. The logic is updated to apply a considerable force away from the repeller, and when the particle approaches an arbitrary threshold

### Blend mode

Particles are drawn with regular shapes, like circles or rectangles as done so far, or with images.

```lua
function Particle:render()
  love.graphics.setColor(1, 1, 1, self.lifespan)
  love.graphics.draw(img, self.position.x, self.position.y, 0, 1, 1, img:getWidth() / 2, img:getHeight() / 2)
end
```

Images are also useful to introduce blend modes, modifying the default pixel value of overlapping entities. With the `add` option, the rgb components are added to make the image brighter and eventually white. This is useful for instance to simulate fire particles.

```lua
function ParticleSystem:render()
  love.graphics.setBlendMode("add")
  -- draw particles
end

```

_Please note:_

- in the demo the image is initialized as a drawable object in `love.load`. This is a much preferable solution to include the instruction in the particle entity, in which case the script would continuously load the file

  ```lua
  function love.load()
    img = love.graphics.newImage("particle.png")
  end
  ```

## 05 - Physics Libraries

With vectors, forces, trigonometry it is possible to simulate a first environment with rudimentary physics. It is possible to refine the simulation considering more complex natural phenomena, but one alternative comes in the form of physics libraries. Here you find code by other developers already considering the issue of simulating life, simulating nature. A physics engine provides a level of complexity only grasped in the previous sections. The price is that you need to learn about the library, its requirements and also limitations.

_Please note:_

- while the chapter is devoted to two libraries, Box2D and Verletlib, I cover the examples of the first library only

- Love2D includes the Box2D library in the `love.physics` module

### Box2D

Fundamentally, a simulation with Box2D works in two steps: set up and update. In the setup phase, you initialize the world, and populate the environment with however many entities are necessary. In the update phase, Box2D considers the underlying physics to update the world as necessary; there is no need to consider the position, velocity, acceleration and forces of the individual entities.

Box2D considers all the underlying physics, but it is however necessary to set up the world with the procedure and syntax prescribed by the library.

#### Core elements

A Box2D simulation starts with a _world_. This is where the simulation defines the features of the environment, like its gravity.

```lua
GRAVITY = 20
function love.load()
  world = love.physics.newWorld(0, GRAVITY)
end
```

Box2D works with meters, kilograms and real-world units. Since Love2D works with pixels instead, it is useful to adapt the measures with the `setMeter` function.

```lua
GRAVITY = 20
GRAVITY_METER = 9.81
function love.load()
  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * GRAVITY_METER)
end
```

Once initialized, the world is updated with the `update()` function, considering every single entity included in the simulation.

```lua
function love.update(dt)
  world:update(dt)
end
```

To populate the world, each entity needs three parts: a body, a shape and a fixture.

- a _body_ is but a container describing the position, velocity and other defining features of the entity. Consider it similar to the `Mover` entity introduced in previous chapters.

  ```lua
  body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 4, "dynamic")
  ```

  The function introduces a type between one of three options: `static`, `dynamic` and `kinematic`. A dynamic body is one subject to the forces of the world, and one colliding with other entities. The remaining two types are discussed in later sections.

- a _shape_ provides the visual representation for the body, and is ultimately essential to define how a collision occurs.

  ```lua
  shape = love.physics.newCircleShape(RADIUS)
  ```

  Different functions provide different geometries, like circles, rectangles, polygons. The parameters vary according to the desired shape, considering for instance the radius for a circle.

- a _fixture_ is attaches a body and shape together.

  ```lua
  fixture = love.physics.newFixture(body, shape)
  ```

  The fixture is also where the entity can set other features, like density, restitution.

This is enough to have the world consider and update an object. To provide a visual then, Love2D provides different methods to retrieve the defining features of the bodies. In the context of a circle, `body:getX()`. `body:getY()` and `shape:getRadius()` allow to find the measures for the circle"s position and radius.

#### Particles

The demo works to create two entities dedicated to different shapes, a circle and a rectangle, and to populate a table with multiple copies of each. Adding multiple objects is also important to stress the importance of removing entities when they are no longer necessary. Removing items involves two steps:

- update the table so that the bodies are not rendered in `love.draw`

  ```lua
  table.remove(particles, i)
  ```

- update the world so that the bodies are no longer considered in the simulation

  ```lua
  particles[i].body:destroy()
  ```

  Without this line the window doesn"t show the bodies, but their position, movement and collision is still computed by Box2D. It is here essential to math the data structure evaluated by Love2D with the world simulated by Box2D.

#### Fixed

A previous section introduced how bodies have different types. By default an object is static, but it"s possible to modify this value already in the declaration of the body. This is what the previous demo achieved in `love.physics.newBody()`.

```lua
love.physics.newBody(world, x, y, "dynamic")
```

Shortly, a body can be _static_, fixed in the world and not subject to its forces, _dynamic_, reacting to the world"s gravity, forces, and collisions, _kinematic_, not subject to forces, but manually moved through its velocity. Consider for instance a platform (fixed), a ball (dynamic) or a character directly controlled by the player (kinematic).

_Please note:_

- the demo populates the world with one platform, but allows to include more fixed objects with mouse input. Drag the cursor from point to point to generate a new platform

#### Curvy boundary

A curved surface is introduced with a `ChainShape`. This particular shape accepts as argument a series of points, which are then connected to make up the object. Using a particular distribution or a trigonometric function, the effect is that the points produce the desired visual.

_Please note:_

- the demo creates a chain shape with the cosine function. In future projects, however, the `Terrain` entity is modified to experiment with other values and distributions.

#### Complex shapes

There are at least two different approaches to building complex shapes:

1. use a `PolygonShape`, detailing the vertices of the desired outline;

2. fix multiple shapes to the same body.

The second approach is the topic of the demo, and the reason the `ComplexShape` entity actually introduces two rectangle shapes.

#### Joint

A joint creates a connection between multiple bodies. There are different types, each with its own usefulness and defining features. For instance:

- a distance joint connects two bodies with a string. Attributes like frequency and damping ratio allow the string to be elastic

- a revolute joint, anchors a body to a point and rotates the entity around the anchor

- a mouse joint connects a body to an `x`, `y` point. In the demo it is used to have a circle tied to the position of the mouse cursor, but only when said mouse is pressed in the window

_Please note:_

- it is enough to initialize a joint in the world to affect the simulation.

  ```lua
  local joint =
    love.physics.newDistanceJoint(
    circleA.body,
    circleB.body,
    circleA.body:getX(),
    circleA.body:getY(),
    circleB.body:getX(),
    circleB.body:getY()
  )
  ```

  There is no need to draw a matching visual for the joint to have effect. Whatsmore, there is no need to have a reference to the joint itself; consider how in _Distance joint_ the `PairShape` entity doesn"t include the joint in its definition (the line is commented out).

  ```lua
  local this = {
    ["circles"] = {circleA, circleB}
    -- ["joint"] = joint
  }
  ```

  A reference is useful in the moment you need to modify the joint. Consider for instance how the revolute joint changes the speed using the horizontal coordinate of the mouse cursor, or again how the mouse joint is destroyed as the mouse is released.

#### Forces

Re-introducing the topic from previous chapters, it is possible to affect a Box2D simulation applying a force directly on a body.

```lua
Body:applyForce(fx, fy)
```

_Please note:_

- in the _Forces_ folder you find two demo, simulating a gust of wind following a mouse press or gravitational force between a fixed object and a series of dynamic particles

- the attractor entity in the demo exploring gravitational force is included as a kinematic body, and updated manually through its velocity considering the position of the mouse cursor

#### Collision events

Often, it is helpful to react to a collision between bodies. Box2D provides an interface to execute some code in the lifecycle of a collision, by referring to a callcback function on the world.

```lua
world:setCallbacks(beginContact)
```

`:setCallbacks` actually accepts up to four arguments, to consider when a contact begins, ends, and when a collision is about to be resolved or has just been resolved.

```lua
world:setCallbacks(beginContact, endContact, preSolve, postSolve)
```

The functions must be defined in the code, and receive a series of arguments describing the collision and the objects involved. More accurately, `beginContact` receives the fixtures of the objects involved, and a table describing the collision.

```lua
function beginContact(f1, f2, collision)

end
```

The collision occurs between two objects coming into contact with each other. It is here extremely useful to know which objects are however involved. To this end, a fixture can describe a label with a `userdata` field.

```lua
fixture:setUserData("attractor")
```

The label is then evaluated in the body of the `beginContact` function.

_Please note:_

- in the demo, the idea is to apply a repulsing force when a particle collides with the attractor. The data structure collecting the particles is modified to have the table use the keys with the same value as the `userdata` field. This is helpful to refer to the particular particle, but requires a small adjusment in the iterator function. `ipairs` works with sequences, while `pairs` is equipped to loop through key-value pairs.

## 06 - Autonomous Agents

With the chapter the idea is to include entities capable of moving on their own, on the basis of a desire. These entities share three defining features:

- a limited ability to perceive the environment

- the ability to process the environment to formulate an action

- the lack of a leader, of an entity detailing the agent's eventual movement

The goal is to run a simulation without a pre-ordained structure, and analyze the interaction between the independent entities.

The demos are inspired by the book which itself cites as inspiration the work of _Craig Reynolds_ on algorithmic steering behaviors.

### Agency

In the folder you find several examples to illustrate the concept of _desire_. An entity might desire to move toward a target, or away from an obstacle; this wanting is materialized in a function applying a force on the basis of the surrounding environment.

#### Steering

In the steering example, a `Vehicle` entity is initilized with a structure eerily similar to the `Mover` or `Particle` entities introduced in previous sections. Every entity has a position, velocity and acceleration. Motion is however expressed in three layers:

1. _action selection_: select an action on the basis of a goal or set of goals; for instance, compute the desired velocity as the difference between the position of the vehicle and target

   ```lua
   local desiredVelocity = LVector:subtract(target.position, self.position)
   ```

2. _steering_: formulate a force to materialize the action; for instance, generate a force considering the desired velocity against the current velocity

   ```lua
   local steeringForce = LVector:subtract(desiredVelocity, self.velocity)
   ```

3. _locomotion_: actually move the vehicle; for instance, apply a force to modify the entity's acceleration and velocity

   ```lua
   self:applyForce(steeringForce)
   ```

In the demo, the logic steering the vehicle toward the target is described in the `steer()` method. In the body of the function, the entity computes the desired velocity and steering force, but refines the movement with two additional variables:

- `maxSpeed` describes the magnitude of the vector

  ```lua
  desiredVelocity:normalize()
  desiredVelocity:multiply(self.maxSpeed)
  ```

  The fixed magnitude means that the entity eventually overshoots its trajectory. In a future demo this behavior is modified to have the entity slow down as it approaches the target.

- `maxForce` reduces the force so that the entity changes direction more slowly

  ```lua
  force:limit(self.maxForce)
  ```

  Limiting the influence of the force means that it takes some time for the vehicle to point to the target

_Please note:_

- in the demo the vehicle and target are position at opposite ends, but the target is updated using the mouse coordinates

#### Arriving

The idea is to have the `Vehicle` entity steer toward the target, but then slow down as it gets closer and closer to the target's position.

The function evaluates the desired velocity, but also the distance of the vector.

```lua
local desiredVelocity = LVector:subtract(target.position, self.position)
local distance = desiredVelocity:getMagnitude()
```

The velocity is then multiplied by a value proportional to the actual distance. The smaller the distance, the slower the force. This however, only when the vehicle is in the range of the target.

```lua
if distance < RADIUS_SLOWDOWN then
  -- from [0, RADIUS_SLOWDOWN] to [0, maxSpeed]
  local speed = map(distance, 0, RADIUS_SLOWDOWN, 0, self.maxSpeed)
  desiredVelocity:multiply(speed)
end
```

_Please note:_

- following a mouse click the demo toggles the visibility of the circle in which the vehicle slows down

#### Pursuing

The vehicle moves toward the target considering both its position and velocity. In order to achieve this effect, the target is initialized with a velocity vector, and this vector is modified to have the entity move toward the mouse. The same vector is then incorporated in the `pursue` function of the vehicle in order to modify the desired velocity.

_Please note:_

- following a mouse click the demo toggles the visibility of a circle displaying the desired location for the vehicle

- to highlight how the vehicle actually pursues the target the demo includes two precautions:

  1. `UPDATE_SPEED` is reduced, so that it is more evident how the entity changes direction

  2. `VELOCITY_MULTIPLIER` scales up the velocity of the target so that the vehicle over-estimates where the target is going to be. You could explain this behavior as thinking that velocity begets velocity, and the vehicle presumes the target will continuously move in the same direction

#### Bouncing

The vehicle moves in the window at a constant speed, and changes this behavior in order to respect arbitrary boundaries. This is achieved by applying an force opposite to the desired velocity if the desired velocity would move the entity outside of the boundaries.

_Please note:_

- following a mouse click the demo toggles the visibility of the boundaries

#### Jittering

Following a suggestion included in the book, the vehicle moves toward a point in the vicinity of the target. By choosing a point around the target, signalled by a small circle the vehicle moves unpredictably, and yet pursuing the target.

_Please note:_

- following a mouse click the demo toggles the visibility of the small circle around the target

### Flow field

With a flow field the window is divided in a certain number of columns and rows. In this grid, the cells describe a velocity, which is then picked up by the vehicle as it navigates the environment.

Each cell is attributed an angle, and there are multiple demos which differ in how this angle is computed, as well as a force vector. To compute this vector, the cosine and sine functions identify where the segment should start and end.

```lua
local x1 = math.cos(angle + math.pi)
local y1 = math.sin(angle + math.pi)
local x2 = math.cos(angle)
local y2 = math.sin(angle)
```

Incrementing the angle by `math.pi` allows to find the origin of the segment, half a rotation from the destination. This structure is useful to draw a line without the translate and rotate functions.

From this setup, all the vehicle needs is to find a cell, and apply a force matching the vector.

As mentioned, there are multiple demos which change how the angle is computed:

- in `Random` the value is purely random

  ```lua
  local angle = math.random() * (math.pi * 2)
  ```

- in `2D noise` the value benefits from a noise function with two arguments

  ```lua
  local angle = love.math.noise(offsetX, offsetY) * (math.pi * 2)
  ```

  The concept was first introduced in the demo for randomness and Perlin noise, and has the effect of creating a series of angles connected to one another.

- in `3D noise` the value is computed with a noise function with three arguments

  ```lua
  local angle = love.math.noise(offsetX, offsetY, time) * (math.pi * 2)
  ```

  `time` is initialized at `0` and incremented with each iteration in `Field:update()`, so that the angle smoothly changes over time.

_Please note:_

- it is possible to include additional vehicles by pressing the mouse with the left button

- the visibility of the field is toggled by pressing the mouse with the right button

### Math

The `Math` folder introduces a few concepts essential for future demos.

#### Dot product

The dot product allows to compute the angle between two vectors. It is helpful to build a scalar projection, and ultimately important to introduce a simulation in which vehicles follow a given path. Defined as the multiplication of two vectors, the product is computed as follows:

- multiply the components making up the vectors

  ```text
  ->
  A = (ax, ay)
  ->
  B = (bx, by)

  ->  ->
  A * B = ax * bx + ay * by
  ```

- multiply the magnitude of the two vectors and the cosine of the angle between the same vectors

  ```text
  ->
  A = (ax, ay)
  ->
  B = (bx, by)

  ->  ->   ->    ->
  A * B = |A| * |B| * cos(theta)
  ```

By computing the product with the first formula, it is possible to find the angle solving the second formula for theta.

_Please note:_

- `LVector` is updated to include a function returning the dot product for two input vectors, and a function returning the angle between two vectors (using the dot product itself)

#### Scalar projection

The goal is to find a point on a vector according to another vector, a projection.

```text
->
a /|
 / |
/  |
---o---
   ->
   b
```

Cast a line from the vector `a` to the vector `b` so that the line creates a `90` degrees angle. With this line then, the dot product allows to compute the point making up the projection through the angle.

```text
h /|
 / |
/t |
---o
 ->
 x
```

In terms of math, there are a couple of steps involved:

- consider the angle `t` through the mnemonic _sohcahtoa_, as the cosine of the adjacent, `x`, divided by the hypothenuse, `h`

  ```text
  cos(t) = x / h
  ```

- consider `h` as the magnitude of the vector `a`, so that the adjecent segment, `x`, is computed as

  ```text
                ->
  cos(t) = x / |a|

                ->
  x = cos(t) * |a|
  ```

- notice how the formula for the adjacent segment is similar to the one for the dot product. It is actually the same in the instancethe vector `b` has a magnitude of `1` (is a unit vector)

  ```text
   ->
  |b| = 1
                ->    ->
  x = cos(t) * |a| * |b|
  ```

This means that ultimately, the projection is computed considering the dot product of the normalized `b` vector.

_Please note_:

- the demo builds from the script showcasing the dot product, but swaps the name of the vectors `b` and `a`. This in line with the convention introduced in the book

- the vector `b` points to the right half of the screen, changing the `y` coordinate by a random amount. The value is also updated following a mouse click, to show how the projection works for any vector

### Path following

The dot product and scalar projection are useful as building block for path following, another behavior studied by Craig Reynolds. The idea is to have a vehicle move in the window and follow the trajectory described by a path.

In the folder there are two demos: `Straight` and `Segments`, to show how a vehicle first follows a single straight line and then a series of connected segments.

#### Straight

A `Path` entity includes two vectors for each line, describing where the line should start and end. It also describes a radius to have the vehicle move toward the line with some margin.

In the `Vehicle` entity then, the `follow` function receives the path and modifies the velocity of the vehicle with the following logic:

- find `desiredLocation`, as the vector describing where the entity would be moving with its current velocity

  ```lua
  local velocity = LVector:copy(self.velocity)
  velocity:normalize()
  velocity:multiply(DESIRED_LOCATION_DISTANCE)
  local desiredLocation = LVector:add(self.position, velocity)
  ```

  `DESIRED_LOCATION_DISTANCE` is used to scale the unit vector so that the vehicle looks ahead by a given value. Essentially, however, the location is found by adding position and velocity

- compute the `a` and `b` vectors as described in the scalar projection demo

  - `a` describes the vector between the desired location and the beginning of the path

    ```text
        x  desired location
    -> /
    a x  currentposition
     /
    /
    x------
    path
    ```

    ```lua
    local a = LVector:subtract(desiredLocation, path.start)
    ```

  - `b` describes the vector for the path itself

    ```text
        /
       /
      /
     /
    x------x
      ->
      b
    ```

    ```lua
    local b = LVector:subtract(path.finish, path.start)
    ```

- find the projection through the dot product, again taking inspiration from the scalar projection

  ```lua
  b:normalize()
  b:multiply(TARGET_MULTIPLIER)
  local projection = LVector:multiply(b, LVector:dot(a, b))
  projection:add(path.start)
  ```

  Notice that `b` is normalized, exactly as in the previous demo, but also multiplied by a factor.

  ```lua
  b:multiply(TARGET_MULTIPLIER)
  ```

  The idea is to provide an offset from the projection describing the normal. Without this offset, the vehicle would move to a fixed point describing the perpendicular line connecting point to path.

  Also notice that the vector is incremented by the start vector.

  ```lua
  projection:add(path.start)
  ```

  This is essential to have the projection relative to the path origin.

- with the vector describing the projection, a point on the path, the idea is to move the entity towards the path, but only when exceeding the space given by the radius.

  To compute the distance, consider the projection and the vector describing the desired location

  ```lua
  local dir = LVector:subtract(projection, desiredLocation)
  ```

  The magnitude of this vector details the distance, so that the vehicle is pushed to the projection when exceeding the desired value.

  ```lua
  local distance = dir:getMagnitude()
  if distance > RADIUS_PATH then
    self:seek(projection)
  end
  ```

_Please note:_

- `Vehicle:seek` repeats the logic introduced in the steering demo, with the only difference that the argument of the function is a vector and not a `Target` entity

- the `Path` entity introduces two vectors, for where the line should start and end. I use `finish` instead of `end` since the latter is a reserved word in Lua

- pressing the mouse with the left button has the effect of adding a new vehicle; the right button instead changes the `y` coordinate of the path

#### Segments

The idea is to have a path described not by two vectors, by a series of segments, each with a start and end point.

```lua
local segments = {}
for i = 1, POINTS_PATH do
-- create segment
end
```

To have the segments connected to one another, `Path:new` keeps a reference to the `y` coordinate where each segment should end.

```lua
local previousY = math.random(HEIGHT_MIN, HEIGHT_MAX)
  for i = 1, POINTS_PATH do
    local x1 = xStart + xIncrement * (i - 1)
    local x2 = xStart + xIncrement * i
    local y1 = previousY
    local y2 = math.random(HEIGHT_MIN, HEIGHT_MAX)
    previousY = y2
  end
end
```

From this setup, `Path` is equipped with a `segments` field, storing the desired `x` and `y` coordinates. The `Vehicle` entity then needs to loop through the collection to evaluate the projection on each and every line.

```lua
function Vehicle:follow(path)
  -- knowing desiredLocation
  for i, segment in ipairs(path.segments) do
    -- compute projection
  end
end
```

The idea is to consider here the _closest_ projection which _belongs_ to the actual path. Both conditions are necessary to avoid moving the entity towards the wrong segment.

To check if the projection belongs to the path, it is enough to check if the `x` coordinate falls between the beginning and the end of the segment.

```lua
if projection.x > segment.start.x and projection.x < segment.finish.x then
  -- consider distance
end

```

In order to consider the closest projection, then, the distance is evaluated against a variable intialized with a large value.

```lua
local recordDistance = math.huge
local recordProjection = nil

for i, segment in ipairs(path.segments) do
  -- evaluate distance
  if distance > RADIUS_PATH and distance < recordDistance then
    recordDistance = distance
    recordProjection = projection
  end
end
```

The projection is stored in yet another variable, in the same conditional, and is ultimately used to change the velocity of the vehicle.

```lua
if recordProjection then
  self:seek(recordProjection)
end
```

_Please note:_

- the same notes for the `Straight` demos apply (seek function, add vehicles and create a new path with the mouse cursor)

### Group behaviors

With a group behavior the goal is to model the movement of `Vehicle` entities relative to other entities.

#### Alignment

Align the movement of a vehicle relative to other the entities. In the `align` method, each entity receives the collection describing the instances.

```lua
function Vehicle:align(vehicles)
end
```

From this collection, the idea is to tally every vector describing the velocity.

```lua
local velocity = LVector:new(0, 0)
for i, vehicle in ipairs(vehicles) do
  velocity:add(vehicle.velocity)
end
```

Every vector except the one describing the entity itself. To this end, the `new` method is modified to have each entity distinguished with an `id`.

```lua
local this = {
  -- previous attributes
  ["id"] = math.random()
}
```

The velocity is then added only if the id do not match.

```lua
if vehicle.id ~= self.id then
  velocity:add(vehicle.velocity)
end
```

This has the desired effect of aligning all the entities. However, as explained in the book, it is useful to limit the area of alignment to those vehicles falling in an arbitrary radius. Here, it is helpful to consider the distance between the vectors.

```lua
if distance < DISTANCE_VEHICLE and vehicle.id ~= self.id then
  velocity:add(vehicle.velocity)
end
```

By increasing/decreasing `VEHICLE_DISTANCE`, the demo shows how a vehicle aligns itself with more/less neighbors, and form a larger/smaller cluster.

_Please note:_

- vehicles are added continuously as the mouse is pressed

- `LVector` is updated to have a function return the distance between two vectors. This is achieved by subtracting the vectors and returning the magnitude of the resulting vector.

  ```lua
  function LVector:distance(v1, v2)
    local dir = LVector:subtract(v1, v2)
    return dir:getMagnitude()
  end
  ```

- the velocity is divided by the neighbors actually considered in the `align` function

  ```lua
  velocity:divide(neighbors)
  self:applyForce(velocity)
  ```

#### Separation

Instead of aligning vehicles together, the entities are separated by applying a force away from the surrounding neighbors.

The code is similar to the alignment demo, in that the function loops through the collection of vehicles and considers only those vehicles closer than a given range. However, once a vehicle is within range, the vector is computed by subtracting the entities in reverse order.

```lua
local force = LVector:subtract(self.position, vehicle.position)
```

The idea is to describe a force away from the neighbor. Once computed, the force is added to a vector considering the cumulative vector for every neighbor.

```lua
force:divide(distance)
separationForce:add(force)
```

The force is also weighed by the distance, so that the closer a neighbor is, the more influence it will have on the cumulative vector.

This is enough to consider the influence of the neighbors. However, it is finally useful to scale the vector to avoid excessive values. One way to achieve this is to normalize the vector and scale the result by an arbitrary amount.

```lua
separationForce:normalize()
separationForce:multiply(MAX_SPEED)
self:applyForce(separationForce)
```

_Please note:_

- the same notes for the alignment demo apply

### Combining behaviors

The folder works to show how multiple behaviors can be paired to produce more complex simulations. The forces are computed in dedicated functions and applied in the `applyBehaviors` method.

```lua
function Vehicle:applyBehaviors(vehicles, target)
  local steeringForce = self:steer(target)
  local separationForce = self:separate(vehicles)

  self:applyForce(steeringForce)
  self:applyForce(separationForce)
end
```

By weighing the forces with different factors, the idea is to have a particular force take precedence. For instance, and in the exercise pairing the steering and separation forces, the vector pushing the vehicles away is multiplied by three. This has the net result of creating a swarm of vehicles moving toward the intended target, but giving precedence to avoid any overlap.

#### Cohesion

The exercises include forces already developed in previous demos, in order to steer vehicles toward a target, away from each other or to follow a path. There is however a new force in the `Separation, alignment and cohesion` folder, to express cohesion between the entities.

The idea of the cohesive force is to consider the surrounding neighbors and move the vehicle to the center of the group. This is achieved by considering the sum of the vectors describing the position, and computing the average.

The force is then described by the distance between the vehicle's current position and the newfound vector.

```lua
local cohesionForce = LVector:subtract(position, self.position)
```

## 07 - Cellular Automata

With a cellular automaton the book introduces a system of rules. Such a system has three foundational ingredients:

- a grid of cells

- cells with a concept of state and neighborhood

- state as a function of neighborhood

There are two particular examples in Wolfram's elementary cellular automata and Conway's game of life, but to get started, the folder includes a rudimentary system in `Cellular automaton`.

### Cellular automaton

The example creates a one-dimensional grid, where a cell has up to two neighbors, described by the previous or following unit.

A cell has a boolean value, initialized at random.

```lua
local isAlive = math.random() > 0.5
```

At each iteration, the idea is to modify the state so that a cell is alive only if one of its neighbors is alive.

```lua
local isAlive = aliveNeighbors == 1
```

### Wolfram

Wolfram systems are described by one-dimensional cellular automata, where a ruleset dictates the state of the cell as a function of the state of the same cell and its surrounding neighbors.

Each cell is initialized with a binary value, so that the generation is described by a sequence of `0`s and `1`s. At each iteration then, the idea is to consider the neighboring cell to form a string, like `001` or `010`, and use the string to describe the state from a given set. For instance, a ruleset might be initialized as follows:

```lua
local ruleset = {
  ["111"] = 1,
  ["110"] = 0,
  ["101"] = 1,
  ["100"] = 0,
  ["011"] = 1,
  ["010"] = 0,
  ["001"] = 1,
  ["000"] = 1,
}
```

As a sequence of neighbors describes `101`, the new cell receives the matching state of `1`.

The specific sequence describes the rule, in decimal representation. For instance, ruleset `10101011` describes rule `171`.

The outcome can be described in one of four categories:

- uniformity, where the system settles on a constant value and each generation is equal to the one before it. Consider rule 222;

- repetition, where the system oscillates between generations, creating a predictable pattern. Consider rule 90;

- randomness, where the system behaves unpredictably. Consider rule 30 (until the system reaches the edge of the window);

- complexity, similar to repetition, in that it creates a series of patterns, but also to randomness, in that the patterns do not repeat in a predictable manner

_Please note:_ the `Wolfram` folder contains a series of demos, each with its own purpose:

- `Elementary cellular automata` introduces the system in its most basic version. The `Automata` entity receives a rule as a decimal and creates a ruleset for the three neighbors

- `Neighbors` expands the logic so that the system considers a variable numbers of neighbors before and after the current cell. Notice that the number of rules increases; for instance with three neighbors, and four cells, there are 16 possible configurations leading up to `1111` and sixteen-bit numbers reach `65535` as the greatest rule

- `Wrap around` modifies the update function so that the cells at the edge of the generation consider those at the end and vice-versa as neighbors. In the previous implementation, a cell would use a default value of `0` for unavailable neighbors

- `Rulesets` modifies the default behavior of using the same rule over and over by re-initializing the system every time the generation reaches the bottom of the window. Notice that the size of the individual cell is reduced and the speed at which the automaton is updated is increased; this is to show more cells and rules.

### Game of life

The game of life provides two dimensional cellular automata. More than just an exercise, its works as a starting point for simulations inspired by nature, and specifically inspired by a system of biological reproduction. With a set of limited rules, the idea is to produce pattern and unpredictability similarly to the systems introduced in the Wolfram section. The systems ultimately settle to create uniformity or repeating the same pattern; oscillating as it were.

The two dimensional system is described by a two dimensional collection. Each iteration creates not a new generation, but a new frame of the system.

Each cell is initialized with a boolean at random.

```lua
grid[column][row] = math.random() > 0.5 and 1 or 0
```

With each iteration, then, the idea is to consider the available neighbors and change the state not on the basis of a ruleset, but considering the features of the neighborhood, and speficially the number of neighboring cells which are alive. The rules modify the grid as follows:

- if the cell is alive, it dies with less than two (loneliness) or more than three neighbors (overpopulation)

- if the cell is dead, it comes back alive with exactly three neighbors (birth)

- outside of the previous instances, the cell maintains its previous state (stasis)

_Please note:_ similarly to `Wolfram`, the folder dedicated to the game of life includes a series of demos, each with its own purpose:

- `Game` creates the game in its simplest version, considering the available neighbors and the aforementioned rules

- `Wrap around` has edge cells look at neighbors at the opposite end of the grid. The demo also includes `newGrid` to avoid creating a new collection with every update; the idea is to here update the state in the new collection and then pick up the value in the current set

- `Object oriented` creates a dedicated entity for the cells, and changes the appearance of the simulation to highlight a newborn/just dead cell with a blue/red fill

## 08 - Fractals

Fractals are defined as geometric shapes that can be split into parts, each of which resembles the whole. These shapes share a few common features:

- self-similarity; there is perfect self-similarity, where the part is an exact copy of the whole, and stochastic self-similarity, based on probabilities and randomness

- a fine structure at small scale, which cannot be recreated with Euclidean geometries

- a recursive definition

### Recursive draw

To draw a fractal it is first necessary to introduce the concept of _recursion_, the repeated application of a rule to successive results. In practice, this concept sees a function calling itself, but with different arguments. The exemplary use case is that of a function computing the factorial.

```lua
function factorial(n)
  if n == 1 then
    return 1
  end
  return n * factorial(n - 1)
end
```

Trivially, the factorial of `5` is `5!` and is computed as `5*4*3*2*1`. It can be re-written as `5*4!`, and `5*4*3!` until `1`. It is important to stress this last value because it describes the exit condition, where the recursion should stop. Without such a condition, the function would call itself indefinitely resulting in a stack overflow.

Acknowledging recursion, the demo shows how a `draw` function calls itself to draw circles at different locations and with different radii.

```lua
function draw(x, y, r)
  love.graphics.circle("line", x, y, r)
  if r > RADIUS_MIN then
    draw(x, y, r / 2)
    draw(x + r, y, r / 2)
    draw(x - r, y, r / 2)
    draw(x, y + r, r / 2)
  end
end
```

The function is first called with a value describing the largest circle.

```lua
draw(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, RADIUS_MAX)
```

At each iteration, then, it draws more circles assuming the radius is more than an arbitrary threshold. As the `draw` function calls itself with different maeasures, _every_ circle has a smaller circles to the right, to the left and to the bottom, resulting in an intriguing pattern.

### Sierpinski triangle

With a function drawing a shape and recursively calling itself it is possible draw Sieprinski triangle, a particular type of fractal in which a triangle is subdivided into three, smaller triangle. The structure is based on an equilateral triangle, where the sides are all the same; to find the coordinates of this shape, it is necessary to know the height of the triangle.

```lua
local height = (side * 3 ^ 0.5) / 2
```

Once an equilateral triangle is drawn, the idea is to position the three, smaller triangles to subdivide the shape evenly.

```lua
draw(x - side / 4, y + height / 4, side / 2)
draw(x + side / 4, y + height / 4, side / 2)
draw(x, y - height / 4, side / 2)
```

Notice that the code retains an exit condition, once more to have the function eventually terminate its recursive pattern.

```lua
if side > SIDE_MIN then
  -- draw triangles
end
```

### Cantor rule

A Cantor rule is expressed by a line recursively drawn by dividing the line in three parts, and erasing the middle third. The concept is visualized in the demo showing the different steps.

### Koch line

Building on top of the example introduced with the Cantor rule, a Koch line divides a line in three parts, erases the middle portion and connects the remaining thirds with the sides of an equilateral triangle. It is here necessary to have a reference to the line(s), so that the new segments are created from known coordinates, and to this end, the code is modified to have the line(s) expressed with a dedicated entity and two vectors, detailing where the lines should start and end.

At first, the demo shows a single line spanning the width of the window. Following a mouse click, then, the idea is to have the line segmented following the rules mentioned above. Consider each step as a generation, much similarly to the CA described in the previous chapter.

_Please note:_

- the `Vector` entity is modified to consider a rotation for the `2D` vector. The functionality is essential to figure out the location of the point making up the equilateral triangle in the middle third, and modifies the `x` and `y` component of the vector according to the input angle and the rules described by the rotation matrix.

  ```lua
  function Vector:rotate(theta)
    local x1 = self.x * math.cos(theta) - self.y * math.sin(theta)
    local y1 = self.x * math.sin(theta) + self.y * math.cos(theta)
  end
  ```

- by pressing the right button of the mouse cursor the line is animated in the `y` coordinate describing the end of each line (except the last one)

### Koch snowflake

Following a suggestion from the book, the demo reiterates the concept introduced in the `Koch line` to produce a regular polygon where the sides are actually Koch lines. The `Snoflake` entity is initialized with a certain number of sides and generations, with default values describing a triangular shape after `5` iterations. Following a mouse press, the shape is re-initialized with a random number of sides in the `[3, 10]` range.

The demo includes a bit of math, mostly to find the coordinates of the line segments, but also to have the size of the polygon change depending on the number of sides. The idea is to have a variable `RADIUS` describe the radius of the circle wrapping around the polygon, and compute the length of the side and of the apothem in order to keep the shape inside the edges of the window and exactly in the center.

### Tree

Trees are useful to describe fractals without perfect self-similarity. By modifying the shape with random values and probabilities the idea is to avoid a stylized, symmetric shape to find another way to emulate nature.

The folder includes multiple demos to explore the topic:

- `Transformation matrix` creates a deterministic tree with a specific production rule:

  1. draw a line

  2. rotate to the left and to the right, each time drawing a shorter line

  3. repeat step 2 until an arbitrary exit condition, for instance a line shorter than a given number

  The rule is implemented with a recursive function and benefiting from the `push` and `pop` functions; these functions allow to save and retrieve a particular coordinate, so that the line is drawn from a specific advantage point.

  _Please note:_ following the mouse cursor, the demo maps the horizontal coordinate to the angle used to rotate the line, and in the `[0, math.pi / 2]` range

- `Object oriented` drops the recursive draw function to create a `Tree` and `Line` entity.

  The idea is to have a tree describes lines in generations, and have the `:generate()` function produce branches on the basis of the last generation

  _Please note:_ it is possible to preserve recursion by having the `:generate()` function call itself; this is exactly what is achieved in the demos which follow

- `Stochastic` includes randomness and probability to have the branches change in number, angle and length. This is in line with the purpose of the tree fractal, to show stochastic, non-deterministic shapes

- `Noise` animates the last generation of trees modifying the `finish` vector with a noise function

### L-system

An L-system is a grammar-based sytem, a way to write strings that is adapted in the demos to map characters to particular drawing instructions. It is ultimately useful to describe production rules through strings, commanding an entity with a series of instructions.

Such a system is characterized by three defining features:

- an _alphabet_ describing the allowed characters; for instance `A` and `B`

- an _axiom_ detailing a string for the initial state, for generation zero; for instance `A`

- a _rule_, a production rule applied recursively to the string; for instance, a rule replacing every character `A` with the sequence `ABA` and every character `B` with the sequence `BBB`

Generation after generation, the rule makes it possible to build a sentence with a variety of characters.

The folder includes a few demos to illustrate the point:

- with `Grammar` the idea is to show a the sentence generation after generation

- with `Cantor rule` the goal is to re-create the visual proposed in the folder bearing the same name, but with an L-system. The production rule is exactly the same as the one proposed earlier, where each character `A` creates a line, and each character `B` creates whitespace between segments

- with `Turtle` the folder contemplates more complex systems, where an entity is instructed to move in the window according to a more rich alphabet and a prescribed ruleset. The demos differ in terms of axiom, rules, but also length and angle. The `Turtle` entity and the grammar system, on the other end, are repeated in every folder

_Please note:_

- Lua has no concept of a string buffer, but the table provides a similar benefit. Instead of modifying a string through concatenation and the `..` operator, each character is added to a table and the table is finally joined together through the `concat` function

  ```lua
  local next = {}
  for i = 1, #sentence do
    next[#next + 1] = RULE[sentence:sub(i, i)]
  end
  sentence = table.concat(next)
  ```

## 09 - Genetic Algorithms

The chapter introduces genetic algorithms to first produce a series of characters matching an input string, a problem which cannot be feasibly solved with a brute force approach. From this starting point, the usefulness of the algorithm is expanded to consider additional scenarios, like having particles find the most efficient route from point to point.

### Theory

Inspired by actual biological evolution and specifically darwinian natural selection, genetic algorithms consider three key principles:

- _heredity_, a way to pass data from generation to generation

- _variation_, a way to change the properties between generations

- _selection_, a way to pick and choose property over another

The principles are put into practice in a series of steps, which can be immediately split in two categories: setup and draw.

_Please note:_ the steps are detailed in the context of a specific problem, writing a desired sentence, but the logic is applied to a more varied type of problems.

#### Setup

At the start of the algorithm, the goal is to create a population of `N` elements with random genetic material. For instance, and for the problem at hand, the population is a collection of words as long as the desired sentence, and with random letters from the alphabet.

The larger, the more varied a population is, the easier it is to find a solution. In the instance of the sentence, the more words, and the more characters are represented in the population, the more rapidly the algorithm will find a match. The size of the population, however, affects the algorithm negatively as well, as the program needs to process a large set of values.

#### Draw

Continuously, the algorithm goes through a series of steps with the idea of constantly improving a fitness value.

1. selection: calculate the fitness for the elements of the population in order to decide which element to pick; for instance, consider the number of matching characters between the words in the population and the desired sentence

2. reproduction: pick two elements, two parents, on the basis of a criterium; for instance, pick elements with a probability directly poportional to the fitness value

Starting from two elements, the idea is to produce a new value in the population. This is where heredity comes into play, as the new value depends on the genetic material (the characters) of the parents (the two words). The genetic material is influenced by:

    a. crossover, where the element is created directly from the parents' material; for instance a word picks the first half of one parent, and the second half of the other

    b. mutation, where the element has a chance to produce a different trait; for instance, a certain probability to use a character at random

Mutation allows to cope with a population that doesn't have the traits desired in the solution; for instance, a set of words without a character used in the sentence.

Similarly to the size of the population in the setup phase, there are many variables affecting the efficiency and efficacy of the algorithm. Among these values, the probability to introduce a different trait contributes to find a solution, but if excessive makes it harder to improve the fitness score. For instance, the more random the number of characters, the more the algorithm will try to find a solution in the insurmountable way described earlier, picking characters at random.

### Shakesperian monkey

The demo works to illustrate the brute force approach of finding a match for a four letter word. While ineffective, it also works to introduce the building blocks for the genetic algorithm:

- `getRandomCharacter` returns a random character between `a` and `z` lowercase; the string library allows to rapidly switch between character and numerical representation, but it is important to stress the importance of the decided range.

  ```lua
  string.byte("a") -- 97
  string.byte("z") -- 122
  ```

  With a sentence including spaces, punctuation and other special characters, it is essential to widen the set of possible values.

  ```lua
  string.byte(" ") -- 32
  ```

- `getRandomWord` returns a sequence of characters according to the input length.

  The characters are actually added to a table, and the function ultimately returns a string by concatenating the values.

  ```lua
  return table.concat(word)
  ```

  This is in line with a consideration made for the `L-system` demos, which argued for tables as a substitude for string buffers. It is more efficient for lua to add items to a table than it is to concatenate characters to a string.

With a four letter word and twenty-six possible characters, the odds of finding a match are already a measly `1` in `456 976`, motivating a different approach.

### Simplified algorithm

_Please note:_ the demo differs from the logic discussed in the book in that the logic is described in functions instead of dedicated entities, like `Population` or `DNA`. This is on purpose to have the project comparable with `Shakesperian monkey`. The next demo implements the object-oriented version.

Building on top of the previous demo, the program introduces the steps of the traditional genetic algorithm in the `love.load` and `love.update` functions (setup and draw).

#### Setup

In `love.load` the script initializes a population of random words, benefiting from the functions introduced in the previous demo, `getRandomWord` and `getRandomCharacter`.

#### Draw

In `love.update`, and as long as a match is not found, the script repeats a series of steps in order to modify the original population with values associated with a greater fit.

`selection` works here as the mating pool described in the book. A collection where the words of the population are included in a number proportional to their fitness value.

```lua
local selection = getSelection(population, sentence)
```

`getSelection` loops through the population and computes the fitness for each and every word, before including a comparable number of copies in the colleciton.

```lua
function getSelection(population, sentence)
  local selection = {}

  for i, word in ipairs(population) do
    local fitness = getFitness(word, sentence)
    for j = 1, fitness do
      table.insert(selection, word)
    end

  return selection
end
```

`getFitness` counts the number of matches between word and sentence.

```lua
function getFitness(word, sentence)
  local fitness = 0
  for i = 1, #sentence do
    if word:sub(i, i) == sentence:sub(i, i) then
      fitness = fitness + 1
    end
  end

  return fitness
end
```

With a given `selection`, the idea is to essentially replace the old population with new values, children created from parents picked from the mating pool.

```lua
-- in love.update
for i = 1, #population do
  local child = getChild(selection)
  population[i] = child
end
```

`getChild` implements the reproduction discussed earlier considering two parents, picked at random from the selection. Here you find both a crossover and a mutation:

- crossover: the child inherits letters from the parents alternating between the two

  ```lua
  for i = 1, #sentence do
    child[#child + 1] = i % 2 == 1 and p1:sub(i, i) or p2:sub(i, i)
  end
  ```

- mutation: with given odds, the child picks a character at random

  ```lua
  for i = 1, #sentence do
    if math.random(MUTATION_ODDS) == 1 then
      child[#child + 1] = getRandomCharacter()
    else
      -- inherit
    end
  end
  ```

And that is essentially it for the genetic algorithm. With each iteration, `population` includes fitter and fitter values, until a children is able to reproduce the input sentence.

The rest of the logic described in `love.update` is useful to:

1. identify the word in the population with the best fit

2. stop the iterative process when the input is reproduced

3. store the best fit in a `words` collection, used to show the result in the window

<!-- TODO:
- create traditional algorithm (Population, entity, mapping function)
-->
