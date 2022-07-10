-- Created by whibri | GitHub: @Danker69

local function lerp(start: number, finish: number, alpha: number): number
    return start + ((finish - start) * alpha)
end

local Vec64 = {}
Vec64.__index = Vec64

function Vec64.new(x: number?, y: number?, z: number?)
    local t = {}
    t.__index = t
    t.__tostring = function(self: Vec64)
        return tostring(self.X) .. ", " .. tostring(self.Y) .. ", " .. tostring(self.Z)
    end
    t.__concat = function(self: Vec64, value: Vec64)
        if not value.X then
            error("Concatenated value was not a Vec64!")
        end
        return
            tostring(self.X) .. ", " .. tostring(self.Y) .. ", " .. tostring(self.Z) .. "\n" ..
            tostring(value.X) .. ", " .. tostring(value.Y) .. ", " .. tostring(value.Z)
    end
    t.__eq = function(self: Vec64, value: Vec64)
        local xyz = {"X", "Y", "Z"}
        for i = 1, #xyz do
            local val = xyz[i]
            if self[val] ~= value[val] then
                return false
            end
        end
        return true
    end
    t.__unm = function(self: Vec64)
        return Vec64.new(-self.X, -self.Y, -self.Z)
    end
    t.__add = function(self: Vec64 | number, value: Vec64 | number)
        if type(value) == "number" then
            return Vec64.new(self.X + value, self.Y + value, self.Z + value)
        end
        if type(self) == "number" then
            return Vec64.new(value.X + self, value.Y + self, value.Z + self)
        end

        local x = self.X + value.X
        local y = self.Y + value.Y
        local z = self.Z + value.Z

        return Vec64.new(x, y, z)
    end
    t.__sub = function(self: Vec64 | number, value: Vec64 | number)
        if type(value) == "number" then
            return Vec64.new(self.X - value, self.Y - value, self.Z - value)
        end
        if type(self) == "number" then
            return Vec64.new(value.X - self, value.Y - self, value.Z - self)
        end

        local x = self.X - value.X
        local y = self.Y - value.Y
        local z = self.Z - value.Z

        return Vec64.new(x, y, z)
    end
    t.__mul = function(self: Vec64 | number, value: Vec64 | number)
        if type(value) == "number" then
            return Vec64.new(self.X * value, self.Y * value, self.Z * value)
        end
        if type(self) == "number" then
            return Vec64.new(value.X * self, value.Y * self, value.Z * self)
        end

        local x = self.X * value.X
        local y = self.Y * value.Y
        local z = self.Z * value.Z

        return Vec64.new(x, y, z)
    end
    t.__div = function(self: Vec64 | number, value: Vec64 | number)
        if type(value) == "number" then
            return Vec64.new(self.X / value, self.Y / value, self.Z / value)
        end
        if type(self) == "number" then
            return Vec64.new(value.X / self, value.Y / self, value.Z / self)
        end

        local x = self.X / value.X
        local y = self.Y / value.Y
        local z = self.Z / value.Z

        return Vec64.new(x, y, z)
    end
    t.__pow = function(self: Vec64 | number, value: Vec64 | number)
        if type(value) == "number" then
            return Vec64.new(self.X^value, self.Y^value, self.Z^value)
        end
        if type(self) == "number" then
            return Vec64.new(value.X^self, value.Y^self, value.Z^self)
        end

        local x = self.X^value.X
        local y = self.Y^value.Y
        local z = self.Z^value.Z

        return Vec64.new(x, y, z)
    end
    t.__mod = function(self: Vec64 | number, value: Vec64 | number)
        if type(value) == "number" then
            return Vec64.new(self.X % value, self.Y % value, self.Z % value)
        end
        if type(self) == "number" then
            return Vec64.new(value.X % self, value.Y % self, value.Z % self)
        end

        local x = self.X % value.X
        local y = self.Y % value.Y
        local z = self.Z % value.Z

        return Vec64.new(x, y, z)
    end

    local mt = setmetatable({}, t)

    mt.X = x or 0
    mt.Y = y or 0
    mt.Z = z or 0

    function t:Magnitude(): number
        return math.sqrt(self.X^2 + self.Y^2 + self.Z^2)
    end

    function t:Unit(): Vec64
        return Vec64.new(
            self.X / self:Magnitude(),
            self.Y / self:Magnitude(),
            self.Z / self:Magnitude()
        )
    end

    function t:Cross(vector: Vec64)
        return Vec64.new(
            self.Y * vector.Z - self.Z * vector.Y,
            self.Z * vector.X - self.X * vector.Z,
            self.X * vector.Y - self.Y * vector.X
        )
    end

    function t:Dot(vector: Vec64): number
        return
            self.X * vector.X +
            self.Y * vector.Y +
            self.Z * vector.Z
    end

    function t:FuzzyEq(vector: Vec64, epsilon: number): boolean
        local x = self.X - vector.X
        local y = self.Y - vector.Y
        local z = self.Z - vector.Z

        local new = Vec64.new(x, y, z)
        local mag = new:Magnitude()

        if mag <= epsilon then
            return true
        end
        return false
    end

    function t:Lerp(vector: Vec64, alpha: number)
        return Vec64.new(
            lerp(self.X, vector.X, alpha),
            lerp(self.Y, vector.Y, alpha),
            lerp(self.Z, vector.Z, alpha)
        )
    end

    function t:Max(...: Vec64)
        local vecs = {...}
        local max = vecs[1].X -- placeholder

        for i = 1, #vecs do
            local vec = vecs[i]
            max = math.max(max, vec:AsTuple())
        end
        return Vec64.new(max, max, max)
    end

    function t:Min(...: Vec64)
        local vecs = {...}
        local min = vecs[1].X

        for i = 1, #vecs do
            local vec = vecs[i]
            min = math.min(min, vec:AsTuple())
        end
        return Vec64.new(min, min, min)
    end

    function t:AsTuple(): (number, number, number)
        return self.X, self.Y, self.Z
    end

    function t:ToVector3() -- Only works in Roblox environments!!
        if game == nil or workspace == nil then
            print("Roblox environment not detected! Returning Vec64...")
            return self
        else
            return Vector3.new(self:AsTuple())
        end
    end

    return mt
end

Vec64.zero = Vec64.new(0, 0, 0)
Vec64.one = Vec64.new(1, 1, 1)
Vec64.xAxis = Vec64.new(1, 0, 0)
Vec64.yAxis = Vec64.new(0, 1, 0)
Vec64.zAxis = Vec64.new(0, 0, 1)

export type Vec64 = typeof(Vec64.new(0, 0, 0))
return Vec64