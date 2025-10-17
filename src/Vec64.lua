-- Created by whibri | GitHub: @Danker69

local function lerp(start: number, finish: number, alpha: number): number
    return start + ((finish - start) * alpha)
end

local function xtypeof(v: any)
    local defType = type(v)

    if defType == "table" then
        return v.__type or type(v)
    end

    return defType
end

-- wahhh microoptimizations wahhh
local sqrt = math.sqrt
local max = math.max
local min = math.min

-- Type definitions for the Vec64 instance and module
type Vec64Instance = {
    X: number,
    Y: number,
    Z: number,
    __type: "Vec64",

    __tostring: (self: Vec64Instance) -> string,
    __concat: (self: Vec64Instance, value: Vec64Instance) -> string,
    __eq: (self: Vec64Instance, value: Vec64Instance) -> boolean,
    __unm: (self: Vec64Instance) -> Vec64Instance,
    __add: (self: Vec64Instance, value: Vec64Instance) -> Vec64Instance,
    __sub: (self: Vec64Instance, value: Vec64Instance) -> Vec64Instance,
    __mul: (self: Vec64Instance | number, value: Vec64Instance | number) -> Vec64Instance,
    __div: (self: Vec64Instance, value: Vec64Instance | number) -> Vec64Instance,
    __pow: (self: Vec64Instance, value: Vec64Instance | number) -> Vec64Instance,
    __mod: (self: Vec64Instance, value: Vec64Instance | number) -> Vec64Instance,

    Magnitude: (self: Vec64Instance) -> number,
    Unit: (self: Vec64Instance) -> Vec64Instance,
    Cross: (self: Vec64Instance, vector: Vec64Instance) -> Vec64Instance,
    Dot: (self: Vec64Instance, vector: Vec64Instance) -> number,
    FuzzyEq: (self: Vec64Instance, vector: Vec64Instance, epsilon: number) -> boolean,
    Lerp: (self: Vec64Instance, vector: Vec64Instance, alpha: number) -> Vec64Instance,
    Max: (self: Vec64Instance, ...Vec64Instance) -> Vec64Instance,
    Min: (self: Vec64Instance, ...Vec64Instance) -> Vec64Instance,
    Components: (self: Vec64Instance) -> (number, number, number),
    Clone: (self: Vec64Instance) -> Vec64Instance,
    ToVector3: (self: Vec64Instance) -> any,
}

type Vec64Module = {
    new: (x: number?, y: number?, z: number?) -> Vec64Instance,
    zero: Vec64Instance,
    one: Vec64Instance,
    xAxis: Vec64Instance,
    yAxis: Vec64Instance,
    zAxis: Vec64Instance,
}

type ConstDef = "zero" | "one" | "xAxis" | "yAxis" | "zAxis"
type FuncDef = "Magnitude"

-- Use a relaxed annotation for the module table because the metatable shape is dynamic

--[=[
    @class Vec64
    The main class holding everything together, uses 64 bit numbers
]=]

--- @prop X number
--- @within Vec64
--- X component of the vector

--- @prop Y number
--- @within Vec64
--- Y component of the vector

--- @prop Z number
--- @within Vec64
--- Z component of the vector

--[=[
    @class Vec64Module
]=]
--- @prop zero Vec64
--- @within Vec64Module
--- Returns a new [Vec64] component (0, 0, 0)

--- @prop one Vec64
--- @within Vec64Module
--- Returns a new [Vec64] component (1, 1, 1)

--- @prop xAxis Vec64
--- @within Vec64Module
--- Returns a new [Vec64] component (1, 0, 0)

--- @prop yAxis Vec64
--- @within Vec64Module
--- Returns a new [Vec64] component (0, 1, 0)

--- @prop zAxis Vec64
--- @within Vec64Module
--- Returns a new [Vec64] component (0, 0, 1)

local Vec64: any
Vec64 = setmetatable({}, {
    __index = function(vec64: any, index: ConstDef | FuncDef)
        if index == "zero" then
            return Vec64.new(0, 0, 0)
        elseif index == "one" then
            return Vec64.new(1, 1, 1)
        elseif index == "xAxis" then
            return Vec64.new(1, 0, 0)
        elseif index == "yAxis" then
            return Vec64.new(0, 1, 0)
        elseif index == "zAxis" then
            return Vec64.new(0, 0, 1)
        end

        return
    end
})

--[=[
    @within Vec64Module
    @return Vec64

    Creates a new instance of [Vec64]
]=]
function Vec64.new(x: number?, y: number?, z: number?)
    local t = {}
    t.__type = "Vec64"
    t.__index = t

    t.__tostring = function(self: Vec64Instance): string
        return (`{self.X}, {self.Y}, {self.Z}`)
    end

    t.__concat = function(self: Vec64Instance, value: Vec64Instance): string
        if xtypeof(self) ~= "Vec64" then
            error("Concatenated value was not a (Vec64)!")
        end

        return (`{self:__tostring()}"\n"`) .. (`{value:__tostring()}`)
    end

    t.__eq = function(self: Vec64Instance, value: Vec64Instance): boolean
        local xyz = {"X", "Y", "Z"}
        for i = 1, #xyz do
            local val = xyz[i]
            if self[val] ~= value[val] then
                return false
            end
        end
        return true
    end

    t.__unm = function(self: Vec64Instance): Vec64Instance
        return Vec64.new(-self.X, -self.Y, -self.Z)
    end

    t.__add = function(self: Vec64Instance, value: Vec64Instance): Vec64Instance
        assert(xtypeof(self) == "Vec64", "Self not a Vec64")
        assert(xtypeof(value) == "Vec64", "Value not a Vec64")

        return Vec64.new(self.X + value.X, self.Y + value.Y, self.Z + value.Z)
    end

    t.__sub = function(self: Vec64Instance, value: Vec64Instance): Vec64Instance
        assert(xtypeof(self) == "Vec64", "Self not a Vec64")
        assert(xtypeof(value) == "Vec64", "Value not a Vec64")

        return Vec64.new(self.X - value.X, self.Y - value.Y, self.Z - value.Z)
    end

    t.__mul = function(self: Vec64Instance | number, value: Vec64Instance | number): Vec64Instance
        assert(xtypeof(self) == "Vec64" or type(self) == "number", "Left is not a Vec64 nor a number")
        assert(xtypeof(value) == "Vec64" or type(value) == "number", "Right is not a Vec64 nor a number")

        if type(self) == "number" then
            -- self is the scalar, value must be the vector
            assert(type(value) == "table", "Right-hand operand must be a Vec64 when left is a number")
            local v = value :: Vec64Instance
            return Vec64.new(v.X * self, v.Y * self, v.Z * self)
        end

        if type(value) == "number" then
            local s = self :: Vec64Instance
            return Vec64.new(s.X * value, s.Y * value, s.Z * value)
        end

        return Vec64.new(self.X * value.X, self.Y * value.Y, self.Z * value.Z)
    end

    t.__div = function(self: Vec64Instance, value: Vec64Instance | number): Vec64Instance
        assert(xtypeof(self) == "Vec64", "Left is not a Vec64")
        assert(xtypeof(value) == "Vec64" or type(value) == "number", "Right is not a Vec64 nor a number")

        if type(value) == "number" then
            return Vec64.new(self.X / value, self.Y / value, self.Z / value)
        end

        return Vec64.new(self.X / value.X, self.Y / value.Y, self.Z / value.Z)
    end

    t.__pow = function(self: Vec64Instance, value: Vec64Instance | number): Vec64Instance
        assert(xtypeof(self) == "Vec64", "Left is not a Vec64")
        assert(xtypeof(value) == "Vec64" or type(value) == "number", "Right is not a Vec64 nor a number")

        if type(value) == "number" then
            return Vec64.new(self.X ^ value, self.Y ^ value, self.Z ^ value)
        end

        return Vec64.new(self.X ^ value.X, self.Y ^ value.Y, self.Z ^ value.Z)
    end

    t.__mod = function(self: Vec64Instance, value: Vec64Instance | number): Vec64Instance
        assert(xtypeof(self) == "Vec64", "Left is not a Vec64")
        assert(xtypeof(value) == "Vec64" or type(value) == "number", "Right is not a Vec64 nor a number")

        if type(value) == "number" then
            return Vec64.new(self.X % value, self.Y % value, self.Z % value)
        end

        return Vec64.new(self.X % value.X, self.Y % value.Y, self.Z % value.Z)
    end

    local mt = setmetatable({}, t)

    mt.X = x or 0
    mt.Y = y or 0
    mt.Z = z or 0

    --[=[
        Returns the magnitude (distance) of the vector from (0, 0, 0)
        @within Vec64

        @return number
    ]=]
    function t:Magnitude(): number
        return sqrt(self.X^2 + self.Y^2 + self.Z^2)
    end

    --[=[
        Returns the unit (direction) of the vector
        @within Vec64

        @return Vec64
    ]=]
    function t:Unit(): Vec64Instance
        local mag = self:Magnitude()
        return Vec64.new(self.X / mag, self.Y / mag, self.Z / mag)
    end

    --[=[
        Returns the cross product of the two vectors
        @within Vec64

        @param vector Vec64

        @return Vec64
    ]=]
    function t:Cross(vector: Vec64Instance): Vec64Instance
        local nx, ny, nz = self.X, self.Y, self.Z
        return Vec64.new(
            ny * vector.Z - nz * vector.Y,
            nz * vector.X - nx * vector.Z,
            nx * vector.Y - ny * vector.X
        )
    end

    --[=[
        Returns the dot product of the two vectors
        @within Vec64

        @param vector Vec64

        @return Vec64
    ]=]
    function t:Dot(vector: Vec64Instance): number
        return self.X * vector.X + self.Y * vector.Y + self.Z * vector.Z
    end

    --[=[
        Returns true if the other [Vec64] falls within the epsilon radius of this [Vec64]
        @within Vec64

        @param vector Vec64
        @param epsilon number

        @return boolean
    ]=]
    function t:FuzzyEq(vector: Vec64Instance, epsilon: number): boolean
        local nx = self.X - vector.X
        local ny = self.Y - vector.Y
        local nz = self.Z - vector.Z

        local new = Vec64.new(nx, ny, nz)
        local mag = new:Magnitude()
        return mag <= epsilon
    end

    --[=[
        Returns a linearly interpolated [Vec64] between itself and the `vector` goal Vec64 by the fraction `alpha`
        @within Vec64

        @param vector Vec64
        @param alpha number

        @return Vec64
    ]=]
    function t:Lerp(vector: Vec64Instance, alpha: number): Vec64Instance
        return Vec64.new(lerp(self.X, vector.X, alpha), lerp(self.Y, vector.Y, alpha), lerp(self.Z, vector.Z, alpha))
    end

    --[=[
        Returns a [Vec64] where each component is the highest among the respective components of itelf and the provided [Vec64]s
        @within Vec64

        @param ... Vec64

        @return Vec64

        ```lua title="/src/v64MaxTest.luau"
        local vector1 = Vec64.new(3, 54, 9)
        local vector2 = Vec64.new(5, 1, 11)

        local max = vector1:Max(vector2)
        assert(max == Vec64.new(5, 54, 11), "max should equal given Vec64")
        ```
    ]=]
    function t:Max(...: Vec64Instance): Vec64Instance
        local vecs = {...}
        local maxX, maxY, maxZ = self.X, self.Y, self.Z
        for i = 1, #vecs do
            local vec = vecs[i]
            maxX = max(maxX, vec.X)
            maxY = max(maxY, vec.Y)
            maxZ = max(maxZ, vec.Z)
        end
        return Vec64.new(maxX, maxY, maxZ)
    end

    --[=[
        Returns a [Vec64] where each component is equal to the largest component of all given [Vec64]s
        @within Vec64

        @param ... Vec64

        @return Vec64

        ```lua title="/src/v64AbsoluteMaxTest.luau"
        local vector1 = Vec64.new(3, 54, 9)
        local vector2 = Vec64.new(5, 1, 11)

        local max = vector1:Max(vector2)
        assert(max == Vec64.new(54, 54, 54), "max should equal given Vec64")
        ```
    ]=]
    function t:AbsoluteMax(...: Vec64Instance): Vec64Instance
        local vecs = {...}
        local maxC = max(self:Components())

        for i = 1, #vecs do
            local vec = vecs[i]
            maxC = max(maxC, vec:Components())
        end
        return Vec64.new(maxC, maxC, maxC)
    end

    --[=[
        Returns a [Vec64] where each component is the lowest among the respective components of itelf and the provided [Vec64]s
        @within Vec64

        @param ... Vec64

        @return Vec64

        ```lua title="/src/v64MinTest.luau"
        local vector1 = Vec64.new(3, 54, 9)
        local vector2 = Vec64.new(5, 1, 11)

        local min = vector1:Min(vector2)
        assert(max == Vec64.new(3, 1, 9), "min should equal given Vec64")
        ```
    ]=]
    function t:Min(...: Vec64Instance): Vec64Instance
        local vecs = {...}
        local minX, minY, minZ = self.X, self.Y, self.Z
        for i = 1, #vecs do
            local vec = vecs[i]
            minX = min(minX, vec.X)
            minY = min(minY, vec.Y)
            minZ = min(minZ, vec.Z)
        end
        return Vec64.new(minX, minY, minZ)
    end

    --[=[
        Returns a [Vec64] where each component is equal to the smallest component of all given [Vec64]s
        @within Vec64

        @param ... Vec64

        @return Vec64

        ```lua title="/src/v64AbsoluteMinTest.luau"
        local vector1 = Vec64.new(3, 54, 9)
        local vector2 = Vec64.new(5, 1, 11)

        local min = vector1:Max(vector2)
        assert(min == Vec64.new(1, 1, 1), "min should equal given Vec64")
        ```
    ]=]
    function t:AbsoluteMin(...: Vec64Instance): Vec64Instance
        local vecs = {...}
        local minC = min(self:Components())

        for i = 1, #vecs do
            local vec = vecs[i]
            minC = min(minC, vec:Components())
        end
        return Vec64.new(minC, minC, minC)
    end

    --[=[
        Returns the [Vec64]s components as a Tuple
        @within Vec64

        @return (x: number, y: number, z: number)
    ]=]
    function t:Components(): (number, number, number)
        return self.X, self.Y, self.Z
    end

--[=[
        Returns a clone instance of the [Vec64]
        @within Vec64

        @return Vec64
    ]=]
    function t:Clone(): Vec64Instance
        return Vec64.new(self.X, self.Y, self.Z)
    end

    --[=[
        Returns a [Vector3] if the environment is Roblox, otherwise it returns a [Vec64]
        @within Vec64

        @return Vec64 | Vector3
    ]=]
    function t:ToVector3(): Vector3 | Vec64Instance
        if game == nil or workspace == nil then
            print("Roblox environment not detected! Returning Vec64...")
            return self
        else
            return Vector3.new(self:Components())
        end
    end

    return mt :: Vec64Instance
end

export type Vec64 = Vec64Instance
return Vec64 :: Vec64Module
