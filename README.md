[_The Nature of Code_](https://natureofcode.com/book/) introduces many concepts to simulate real-world phenomena with code. Here, I follow the book to learn about these concepts.

The notes which follow are my own. The demos are written in [Lua](https://www.lua.org/) and showcased with [Love2D](https://love2d.org/).

[![github.com/borntofrappe/the-nature-of-code](https://github.com/borntofrappe/the-nature-of-code/blob/master/banner.svg)](https://github.com/borntofrappe/the-nature-of-code)

## Randomness

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

_Please note_:

- the method using probabilities computes the _cumulative_ probability of each option, so that effectively, the for loop is a convenience from a series of `if` statements

  ```lua
  if random < 0.5
  elseif random < 0.55
  elseif random < 0.85
  elseif random < 1
  end
  ```

### Normal distribution

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

- in the demo the normal function is used to generate an assortment of numbers with mean `0` and standard deviation `1`. These values are then used to draw a line, describing the associated bell curve, and move the `Mover` entity. Given the bell curve, however, the entity barely moves from the origin

- `e` is initialized at the top of the script to describe the [_Euler's number_](<https://en.wikipedia.org/wiki/E_(mathematical_constant)>), and is approximated to `2.71828`

- `maxHeight` describes an upper boundary for the vertical dimension of the bell's curve. This is used to avoid cropping the line at the top of the window

- the mapping function works similarly to the method available in the [processing library](https://github.com/processing/p5.js/blob/main/src/math/calculation.js#L450), adapting a value from an range to range

### Custom distribution

One possible way to alter a distribution to fit a particular need comes from Lévi's flight, whereby you pick a position at random, and to avoid sampling the same observation repeatedly, you pick a far off position every once in a while.
Here, the goal is to show a similar distribution, one that skews observations in a continuous range.
Pick two numbers, consider the first one only if it is less than the second. Considering a range in the (0,1) interval, this ensures that the greater the number, the greater of it being picked, validated. The range also provides a quick reference in terms of probability. For instance 0.80 is 80% likely to be picked.

### Perlin noise

The Perlin noise function allows to create a sequence of numbers connected to each other, with the goal of providing smooth random values. You pick numbers from the sequence, and the distance between the numbers dictates the difference between the two. The greater the distance, the more likely the numbers will differ. The smaller the offset, the more likely the numbers will resemble one another.

The function actually accepts one, two or three arguments, to create noise in multiple dimensions. In one dimension, each number is related to the one coming before and after it. In two, it is connected to the numbers representing the possible neighbors in the (x,y) plane. In three, the neighbors considering a third dimension (z) as well. It returns a sequence of numbers in the (0,1) range.

## Vectors

Euclidean/geometric vector, an entity with magnitude and direction. Here they are introduced in the context of a plane with two dimensions, x and y, but fundamentally, they work in the same manner with additional dimensions.
You can think of a vector with two components (again x and y) as an arrow. The length of the arrow describe its distance, the angle relative to an axis its direction. A vector describing the position of a particle details where to position the object from the origin. A vector describing the velocity dictates how to move the same particle.

### Vector Math

Some libraries provide a functionality to perform mathematical operations on vectors (addition, subtraction, multiplication..). Here, however, I am interested in the underlying math.

- add vectors; sum the components of the vectors involved. position.x += velocity.x; position.y += velocity.y;
- subtract vectors; subtract the components of the first vector by the components of the second; position.x -= velocity.x; position.y -= velocity.y;
- multiply by a scalar; multiply each component by the scalar. position.x _= s; position.y _= s; this is useful to scale the vector
- divide by a scalar; divide each component, scaling down the vector. position.x /= s; position.y /= s; here you scale down the vector, you reduce the strength of its components. Be sure that the scalar is different from 0.
- compute the vector magnitude; using pythagorean theorem a^2 + b^2 = c^2, compute the magnitude as the length, the distance between two points considering the x and y component. m = (vector.x^2 + vector.y^2)^2
- normalize vector; divide the vector by its magnitude, obtaining a vector with length 1, a unit vector. This is helpful to have a unit vector with the same direction as the first vector. From this point you can scale the vector to any arbitrary length (by multiplying the unit vector by yet another magnitude)
- limit a vector to a given magnitude; compute the magnitude, and if greater proceed to scale down the vector. Obtain the unit vector, scale the components with the given scalar.

### Velocity

With two vectors describing the position and velocity it is possible to move an object at a constant rate.

position.x += velocity.x; position.y += velocity.y;

### Acceleration

With three vectors, including acceleration, it is possible to move an object with an accelerated rate. Speeding up and slowing down.

velocity.x += acceleration.x; velocity.y += acceleration.x;
position.x += velocity.x; position.y += velocity.y;

To compute the acceleration, there exist different algorithms. With a constant acceleration, you obtain uniform acceleration. With a variable acceleration, you start to have a more varied movement, whereby the object constantly shifts its direction.
Be sure to consider the magnitude of the vector, scaling/limiting the vector to fit the project needs.
By affecting the acceleration, by modifying the magnitude it is possible to emulate more realistic movement.

## Resources

- [The Nature of Code](https://natureofcode.com/)

- [The Nature of Code playlist](https://www.youtube.com/c/TheCodingTrain/playlists?view=50&sort=dd&shelf_id=9) on [The Coding Train YouTube channel](https://www.youtube.com/c/TheCodingTrain)
