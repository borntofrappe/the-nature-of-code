[_The Nature of Code_](https://natureofcode.com/book/) introduces many concepts to simulate real-world phenomena with code. Here, I follow the book to learn about these concepts.

The notes which follow are my own. The demos are written in [Lua](https://www.lua.org/) and showcased with [Love2D](https://love2d.org/).

[![github.com/borntofrappe/the-nature-of-code](https://github.com/borntofrappe/the-nature-of-code/blob/master/banner.svg)](https://github.com/borntofrappe/the-nature-of-code)

## 01 - Randomness

Randomness is used to introduce the book, object oriented programming and a few of the possible ways with which it is possible to simulate real life phenomena.

### [Random](hhttps://repl.it/@borntofrappe/Randomness-Random)

A random function returns a number in a range with the same probability as any number in the same range. The output isn't truly random, but pseudo-random, whereby the function creates a series of numbers and returns one of them. The sequence repeats itself, but over a long stretch of time.

To move a particle at random, it is possible to modify its position in several ways:

- `math.random(4)` with a chain of if statements to move in either of the four directions

- `math.random(3)` to move horizontally, vertically or stand still

- `math.random()` to move by the measure of a floating point number

_Please note:_

- Lua is 1-indexed. In light of this, `math.random(4)` returns a number in the `[1,4]`, while `math.random(3)` returns a number in the `[1,3]` range

- `math.random()` returns the same sequence of random numbers unless you first set a random seed

  ```lua
  function love.load()
    math.randomseed(os.time())
  end
  ```

  It is possible to use `love.math.random`, a function which is automatically seeded by Love2D, but I chose the non-seeded version to stress how the random function returns pseudo-random numbers.

### [Probability](https://repl.it/@borntofrappe/Randomness-Probability)

The probability of a single event is given by the number of outcomes representing the event divided by the number of possible outcomes. The probability of multiple events occurring in sequence is obtained by multiplying the single events. The concept is useful to describe the random functions, but also the distribution of other functions.

With the random function, you can obtain a certain probability with at least two methods:

- initialize a bucket, a container with a set of options and pick at random from the set

- ask for a random number in the `(0, 1)` range and use the value to execute an option with the given probability

_Please note:_

- the method using probabilities computes the _cumulative_ probability of each option, so that effectively, the for loop is a convenience from a series of `if` statements

  ```lua
  if random < 0.5
  elseif random < 0.55
  elseif random < 0.85
  elseif random < 1
  end
  ```

### [Normal distribution](https://repl.it/@borntofrappe/Randomness-Normal-distribution)

A normal distribution (or Gaussian) returns a random number starting from two values: a mean and a standard variation. The idea of the distribution is that numbers are more likely to approach the mean than deviate from it. How often they distance themselves from the mean is described by the standard deviation. With a small deviation, the numbers gather around the mean. Opposedly and with a large deviation, the numbers scatter away from the central value.

#### 68,98,99.7

Given a population and a normal distribution, 68% of the observations fall in the range of the standard deviation, 98% in the range of twice the standard deviation and 99.7% in the range of thrice the same value.

#### Standard deviation

This is beyond the scope of the project, but to compute the standard deviation with a mean and a set of observations: take each observation, subtract the mean and square the result. Sum the result for all observations to gather the _variance_. The standard deviation is the square root of the variance.

#### Normal function

A function `f(x)` returns a number `y` in a normal distribution with mean `mu` and standard deviation `sigma` with the following formula.

```lua
f(x) = 1 / (sigma * (2 * math.pi) ^ 0.5) * e ^ (- 1 / 2 * ((x - mu) / sigma) ^ 2)
```

_Please note:_

- in the demo the normal function is used to generate an assortment of numbers with mean `0` and standard deviation `1`. These values are then used to draw a line, describing the associated bell curve, and move the `Mover` entity

- `e` is initialized at the top of the script to describe the [_Euler's number_](<https://en.wikipedia.org/wiki/E_(mathematical_constant)>), and is approximated to `2.71828`

- `maxHeight` describes an upper boundary for the vertical dimension of the bell's curve. This is used to avoid cropping the line at the top of the window

- the mapping function works similarly to the method available in the [processing library](https://github.com/processing/p5.js/blob/main/src/math/calculation.js#L450), adapting a value from an range to range

### [Custom distribution](https://repl.it/@borntofrappe/Randomness-Custom-distribution)

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

### [Perlin noise](https://repl.it/@borntofrappe/Randomness-Perlin-noise)

The Perlin noise function allows to create a sequence of numbers connected to each other, with the goal of providing smooth random values. You pick numbers from the sequence, and the distance between the numbers dictates the difference between the two. The greater the distance, the more likely the numbers will differ. The smaller the offset, the more likely the numbers will resemble one another.

While it is possible to create a function similar to the Perlin one, Love2D provides a similar functionality with [`love.math.noise`](https://love2d.org/wiki/love.math.noise)

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

<!-- TODO: add live demo for Vectors - Library -->

## 02 - Vectors

Vectors as introduced in the book are _euclidean_ vectors, entities with a magnitude and a direction. They are introduced in the context of a plane with two dimensions, `x` and `y`, but fundamentally, they work in the same manner with additional dimensions.

Think of a vector with two components as an arrow. The length of the arrow describe its distance, while the angle relative to an axis its direction. A vector describing the position of a particle details where to position the object from the origin. A vector describing the velocity dictates how to move the same particle.

_Please note:_

- `Vector.lua` is used to introduce the vector entity with a table

- [the demo in the `Vector` folder](https://repl.it/@borntofrappe/Vectors-Vector) shows two vectors, a position vector centering a circle in the middle of the screen, and a velocity vector radiating from the starting point. The velocity vector is finally updated using the coordinates of the mouse cursor

### [Vector Math](https://repl.it/@borntofrappe/Vectors-Vector-math)

Vectors follow specific rules to compute mathematical operations.

- addition: sum the components

- subtract vectors: subtract the components of the first vector by the components of the second

- multiply by a scalar: multiply each component by the scalar; this operation is useful to scale the vector

- divide by a scalar: divide each component, scaling down the vector; here you scale down the vector, you reduce the strength of its components. Be sure that the scalar is different from 0

- compute the vector's magnitude; using pythagorean theorem, `a^2 + b^2 = c^2`, the magnitude represents the length, the distance between two points considering the `x` and `y` component: `m = (vector.x^2 + vector.y^2)^2`

- normalize vector: divide the vector by its magnitude, obtaining a vector with length 1, a unit vector. This is helpful to have a unit vector with the same direction as the first vector. From this point you can scale the vector to any arbitrary length, by further multiplying the unit vector with the desired magnitude

- limit a vector to a given magnitude; compute the magnitude, and if greater than the input value proceed to scale down the vector to said magnitude. In practice, this operation is achieved by normalizing the vector and scaling the same entity with the input magnitude

_Please note:_

- `Vector.lua` is updated to compute different mathematical operations on the vector itself. Be careful that these methods (add, subtract, multiply and divide) modify the original entity

- `LVector.lua` is introduced as a rudimentary version of the Processing library, and defines several methods to compute roughly the same mathematical operations. The key difference is that the methods do not modify the input vector(s), but return a new entity altogether

### [Velocity](https://repl.it/@borntofrappe/Vectors-Velocity)

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

- in the `Acceleration` folder you find two demos: [`Constant`](https://repl.it/@borntofrappe/Vectors-Acceleration-Constant) setting a positive or negative acceleration with a particular key press, and [`Mouse`](https://repl.it/@borntofrappe/Vectors-Acceleration-Mouse), updating the acceleration to have the particles move toward the mouse cursor

## 03 - Forces

## Forces

The goal is to adapt the concept of forces and Newtonian physics to the simplified environment introduced with vectors.

### Newton's laws

In the simplified environment, a force is described as a vector which causes an object with mass to accelerate.

Newton's first law, arguing that an object at rest stays at rest and an object in motion stays in motion, is adapted by saying that the vector describing the velocity stays constant. The only way for an object to stop, to reach an equilibrium is for the velocity to be affected by a series of forces which cancel its magnitude.

Newton's third law, detailing an action/reaction pair for any force, is partly incorporated in the environment by having a contrasting force applied to a force vector.

Newton's second law, providing a formula to compute a force on the basis of mass and acceleration, is finally essential to the simulation.
This law states that the force is equal to mass times acceleration.

```lua
->      ->
F = m * a
```

In a first approximation, and assuming a mass equal to 1, you can therefore apply a force by directly modifying the acceleration.

```lua
function Mover:applyForce(force)
  self.acceleration = force
end
```

_Please note:_

- in the demo for the `Newton's law` folder a ball is initialized without velocity, nor acceleration. The acceleration vector is then modified in `love.load` by applying a force

  ```lua
  local force = LVector:new(fx, fy)
  mover:applyForce(force)
  ```

### Force accumulation

The previous solution works, but only when a single force is applied. With multiple forces, only the last one is incorporated in the acceleration vector. The implementation is therefore modified to consider the effect of a force as cumulative (force accumulation)

```lua
function applyForce()
acceleration:add(force)
end
```

At every frame, however, it is necessary to reset the acceleration vector. In this manner, the object considers the forces available in the specific frame/instant only, and not the previous forces as well.

```lua
acceleration:multiply(0)
```

### Mass

In a slightly more elaborated construct, the force is weighed by the object mass.

```lua
function applyForce()
f = LVector:divide(force, mass)
acceleration:add(f)
end
```

Be careful not to modify the input force directly.

### Creating forces

In a simulation, a force can be applied following a particular event, consider mouse input generating a wind current, or in order to emulate real world physics. In this last scenario, consider a formula, and try to implement its logic even in a simplified manner. For instance and for a force of friction, you can apply a force opposite to the velocity vector.

With a formula, the goal is to find the direction and magnitude of the force.

#### Gravity

Create a vector pointing downwards and apply the force to the object.

gravity.x = 0
gravity.y = 0.1

applyForce(gravity)

### Friction

Create a vector based on the velocity, changing it's direction and magnitude according to the input vector.

## Resources

- [The Nature of Code](https://natureofcode.com/)

- [The Nature of Code playlist](https://www.youtube.com/c/TheCodingTrain/playlists?view=50&sort=dd&shelf_id=9) on [The Coding Train YouTube channel](https://www.youtube.com/c/TheCodingTrain)
