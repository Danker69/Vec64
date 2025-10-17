---
sidebar_position: 1
---

# Basic Tutorial
Using this is almost the exact same as using a Vector3

# Example use case:
```lua title="/src/MyLovelyVector.luau"
local vector = Vec64.new(4, 6, 7)
local vectorToAdd = Vec64.new(6, 4, 3)

local vectorSum = vector + vectorToAdd
assert(vectorSum == Vec64.new(10, 10, 10), "If this fails then something went horribly wrong.")
```

## Operator Overloads

There's several way you can use operators on your Vec64

### Equality (=)
A Vec64 is equal to another Vec64 when their respective components are the same

```lua title="/src/equalityCheckTest.luau"
local v1 = Vec64.new(1, 1, 1)
local v2 = Vec64.one

assert(v1 == v2, "These should be equal")
```

### Negation (-Vec64)
A Vec64 can be negated, which flips each sign on its respective components

```lua title="/src/negationCheckTest.luau"
local v1 = Vec64.new(1, 1, 1)
local v2 = Vec64.new(-1, -1, -1)

assert(-v1 == v2, "These should be equal")
```

### Addition (+)
A Vec64 can be added onto another Vec64

```lua title="/src/additionCheckTest.luau"
local v1 = Vec64.new(1, 2, 3)
local v2 = Vec64.new(5, 4, 4)

local sum = Vec64.new(6, 6, 7)

assert(v1 + v2 == sum, "These should be equal")
```

### Subtraction (-)
A Vec64 can be subtracted from another Vec64

```lua title="/src/subtractionCheckTest.luau"
local v1 = Vec64.new(10, 5, -5)
local v2 = Vec64.new(4, -2, 3)

local res = Vec64.new(6, 7, -8)

assert(v1 - v2 == res, "These should be equal")
```

### Multiplication (*)
A Vec64 can either be multiplied by another Vec64, or a scalar number

```lua title="/src/multiplicationCheckTest.luau"
local v1 = Vec64.new(1, 0, 11)
local v2 = Vec64.new(2, 9, 4)

local product_v1v2 = Vec64.new(2, 0, 44)

assert(v1 * v2 == product_v1v2, "These should be equal")
```

For scalar values, they can be positioned on either side of the operator
```lua title="/src/multiplicationCheckTest.luau"
local v1 = Vec64.new(1, 0, 11)
local scalar = 2

assert(v1 * scalar == Vec64.new(2, 0, 22), "These should be equal")
assert(scalar * v1 == Vec64.new(2, 0, 22), "These should be equal")
```

### Division (/)
A Vec64 can be divided by another Vec64 or a scalar value

```lua title="/src/divisionCheckTest.luau"
local v1 = Vec64.new(10, 2, 4)
local v2 = Vec64.new(5, 1, 6)

assert(v1 / v2 == Vec64.new(2, 2, 4/6), "These should be equal")
assert(v1 / 2 == Vec64.new(5, 1, 2), "These should be equal")
```

### Exponentiation (^)
A Vec64 can be raised to the power of a number or another Vec64

```lua title="/src/exponentiationCheckTest.luau"
local v1 = Vec64.new(4, 2, 10)
local v2 = Vec64.new(2, 3, 1)

assert(v1 ^ v2 == Vec64.new(16, 8, 10), "These should be equal")
assert(v1 ^ 2 == Vec64.new(16, 4, 100), "These should be equal")
```

### Modulo (%)
You can get the remainder of a modulus operation on a Vec64 by using another Vec64 or a scalar value

```lua title="/src/moduloCheckTest.luau"
local v1 = Vec64.new(5, 10, 2)
local v2 = Vec64.new(3, 5, 4)

assert(v1 % v2 == Vec64.new(2, 0, 2), "These should be equal")
assert(v1 % 2 == Vec64.new(1, 0, 0), "These should be equal")
```