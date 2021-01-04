[_The Nature of Code_](https://natureofcode.com/book/) introduces many concepts to simulate real-world phenomena with code. Here, I try to create a few demos with [Lua](https://www.lua.org/) and [Love2D](https://love2d.org/) to learn about these concepts.

The notes which follow are my own, and try to formalize what I learn from the book and from [the dedicated playlist](https://www.youtube.com/c/TheCodingTrain/playlists?view=50&sort=dd&shelf_id=9) on [The Coding Train YouTube channel](https://www.youtube.com/c/TheCodingTrain).

[![github.com/borntofrappe/the-nature-of-code](https://github.com/borntofrappe/the-nature-of-code/blob/master/banner.svg)](https://github.com/borntofrappe/the-nature-of-code)

## Randomness

Randomness is used to introduce the book, object oriented programming and a few of the possible ways with which it is possible to simulate real life phenomena (the movement of a particle).

### Random

A random function returns a number in a range with the same probability as any number in the same range.
The output isn't truly random, but pseudo-random, whereby the function creates a series of numbers and returns one of them. The sequence repeats itself, but over a long stretch of time.

To move a particle at random, it is possible to modify its position in several ways:

- `math.random(4)` with a chain of if statements to move in either of the four directions

- `math.random(3)` to move horizontally/vertically or stand still

- `math.random()` to move by the measure of a floating point number

_Please note:_

- Lua is 1-indexed. In light of this, `math.random(4)` returns a number in the `[1,4]`. Similarly, `math.random(3)` returns a number in the `[1,3]` range

- `math.random()` returns the same sequence of random numbers unless you first set a random seed

  ```lua
  function love.load()
    math.randomseed(os.time())
  end
  ```

  It is possible to use `love.math.random`, a function which is automatically seeded by Love2D, but I chose the non-seeded version to stress how the random function returns pseudo-random numbers.

### Probability

The probability of a single event is given by the number of outcomes representing the event divided by the number of possible outcomes. The probability of multiple events occurring in sequence is obtained by multiplying the single events

This is handy not only to describe the random functions, but the distribution of other functions.

With the random function, you can obtain a certain probability with at least two methods:

- initialize a bucket, a container with a set of options and pick at random from the set

- ask for a random number in the `(0, 1)` and use the value to execute an option with the cumulative probability

### Normal distribution

A normal distribution (or Gaussian) returns a random number starting from two values: a mean and a standard variation. The idea of the distribution is that numbers are more likely to approach the mean than deviate from it. How often they distance themselves from the mean is described by the standard deviation. With a small deviation, the numbers gather around the mean. Opposedly and with a large deviation, the numbers scatter away from the central value.

#### 68,98,99.7

Given a population and a normal distribution, 68% of the observations fall in the range of the standard deviation, 98% in the range of two and 99.7% in the range of three

#### Standard deviation

This is beyond the scope of the project, but to compute the standard deviation with a mean and a set of observations: take each observation, subtract the mean and square the result. Sum the result for all observations to gather the _variance_. The standard deviation is the square root of the variance.

#### Normnal distribution

A function `f(x)` returns a number `y` in a normal distribution with mean `mu` and standard deviation `sigma` with the following formula.

```lua
f(x) = 1 / (sigma * (2 * math.pi) ^ 0.5) * e ^ (- 1 / 2 * ((x - mu) / sigma) ^ 2)
```

_Please note:_

- `e` is initialized at the top of the script to describe the [_Euler's number_](<https://en.wikipedia.org/wiki/E_(mathematical_constant)>), and is approximated to `2.71828`

- `maxHeight` describes an upper boundary for the vertical dimension of the bell's curve. This is used to avoid cropping the line at the top of the window

- the mapping function works similarly to the method available in the [processing library](https://github.com/processing/p5.js/blob/main/src/math/calculation.js#L450), adapting a value from an input to an output range

### Custom distribution

One possible way to alter a distribution to fit a particular need comes from Lévi's flight, whereby you pick a position at random, and to avoid sampling the same observation repeatedly, you pick a far off position every once in a while.
Here, the goal is to show a similar distribution, one that skews observations in a continuous range.
Pick two numbers, consider the first one only if it is less than the second. Considering a range in the (0,1) interval, this ensures that the greater the number, the greater of it being picked, validated. The range also provides a quick reference in terms of probability. For instance 0.80 is 80% likely to be picked.

### Perlin noise

The Perlin noise function allows to create a sequence of numbers connected to each other, with the goal of providing smooth random values. You pick numbers from the sequence, and the distance between the numbers dictates the difference between the two. The greater the distance, the more likely the numbers will differ. The smaller the offset, the more likely the numbers will resemble one another.

The function actually accepts one, two or three arguments, to create noise in multiple dimensions. In one dimension, each number is related to the one coming before and after it. In two, it is connected to the numbers representing the possible neighbors in the (x,y) plane. In three, the neighbors considering a third dimension (z) as well. It returns a sequence of numbers in the (0,1) range.
