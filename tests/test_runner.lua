-- Tests for Vec64 module
-- Run with the Luau CLI: `luau tests/test_runner.lua`

-- Since we're in the tests directory, tell Luau to also look in the parent's src directory
local function absolutePath()
    local currentPath = debug.info(1, "s")
    if currentPath then
        local lastSlash = string.find(string.reverse(currentPath), "/") or string.find(string.reverse(currentPath), "\\")
        if lastSlash then
            return string.sub(currentPath, 1, #currentPath - lastSlash + 1)
        end
    end
    return "./"
end

-- Add the src directory to the module search path
local testPath = absolutePath()
local Vec64 = require(testPath .. "../src/Vec64")

local eps = 1e-9
local function approx(a, b)
    return math.abs(a - b) <= eps
end

local tests = {}
local function add(name, fn) table.insert(tests, {name = name, fn = fn}) end

add("constructor & components", function()
    local v = Vec64.new(1, 2, 3)
    assert(v.X == 1)
    assert(v.Y == 2)
    assert(v.Z == 3)
    local x, y, z = v:Components()
    assert(x == 1 and y == 2 and z == 3)
end)

add("magnitude", function()
    local v = Vec64.new(1, 2, 3)
    local m = v:Magnitude()
    assert(approx(m, math.sqrt(1 + 4 + 9)))
end)

add("unit", function()
    local v = Vec64.new(3, 0, 4)
    local u = v:Unit()
    assert(approx(u:Magnitude(), 1))
    -- direction preserved
    assert(approx(u.X, 3 / 5) and approx(u.Z, 4 / 5))
end)

add("clone & equality", function()
    local v = Vec64.new(5, 6, 7)
    local c = v:Clone()
    assert(c.X == v.X and c.Y == v.Y and c.Z == v.Z)
    assert(v == c)
end)

add("add & sub", function()
    local a = Vec64.new(1, 2, 3)
    local b = Vec64.new(4, 5, 6)
    local s = a + b
    assert(s.X == 5 and s.Y == 7 and s.Z == 9)
    local d = b - a
    assert(d.X == 3 and d.Y == 3 and d.Z == 3)
end)

add("mul & div scalar", function()
    local v = Vec64.new(2, 3, 4)
    local m = v * 2
    assert(m.X == 4 and m.Y == 6 and m.Z == 8)
    local m2 = 2 * v
    assert(m2.X == 4 and m2.Y == 6 and m2.Z == 8)
    local d = v / 2
    assert(d.X == 1 and d.Y == 1.5 and d.Z == 2)
end)

add("dot & cross", function()
    local a = Vec64.new(1, 0, 0)
    local b = Vec64.new(0, 1, 0)
    assert(a:Dot(b) == 0)
    local c = a:Cross(b)
    assert(c.X == 0 and c.Y == 0 and c.Z == 1)
end)

add("lerp", function()
    local a = Vec64.new(0, 0, 0)
    local b = Vec64.new(2, 2, 2)
    local mid = a:Lerp(b, 0.5)
    assert(approx(mid.X, 1) and approx(mid.Y, 1) and approx(mid.Z, 1))
end)

add("fuzzyeq", function()
    local a = Vec64.new(1, 1, 1)
    local b = Vec64.new(1.0000000001, 1.0000000001, 1.0000000001)
    assert(a:FuzzyEq(b, 1e-8))
end)

add("max & min", function()
    local a = Vec64.new(1, 5, 3)
    local b = Vec64.new(2, 4, 6)
    local m = a:Max(b)
    assert(m.X == 2 and m.Y == 5 and m.Z == 6)
    local n = a:Min(b)
    assert(n.X == 1 and n.Y == 4 and n.Z == 3)
end)

add("abs max & min", function()
    local a = Vec64.new(1, 5, 3)
    local b = Vec64.new(2, 4, 6)
    local m = a:AbsoluteMax(b)
    assert(m.X == 6 and m.Y == 6 and m.Z == 6, "AbsoluteMax failed")
    local n = a:AbsoluteMin(b)
    assert(n.X == 1 and n.Y == 1 and n.Z == 1, "AbsoluteMin failed")
end)

add("toVector3 fallback", function()
    local v = Vec64.new(7, 8, 9)
    local t = v:ToVector3()
    -- in non-Roblox env we expect the same Vec64 instance
    assert(t.X == v.X and t.Y == v.Y and t.Z == v.Z)
end)

-- Run tests
local passed = 0
local failed = {}
for i, t in ipairs(tests) do
    local ok, err = pcall(t.fn)
    if ok then
        print(string.format("[PASS] %s", t.name))
        passed = passed + 1
    else
        print(string.format("[FAIL] %s - %s", t.name, tostring(err)))
        table.insert(failed, {name = t.name, err = tostring(err)})
    end
end

print(string.format("\nPassed: %d/%d", passed, #tests))
if #failed > 0 then
    print("Failures:")
    for _, f in ipairs(failed) do
        print(string.format(" - %s: %s", f.name, f.err))
    end
    local function safe_exit(code)
        if type(os) == "table" and type((os :: any).exit) == "function" then
            (os :: any).exit(code)
        end
        return code
    end
    return safe_exit(1)
else
    print("All tests passed!")
    local function safe_exit(code)
        if type(os) == "table" and type((os :: any).exit) == "function" then
            (os :: any).exit(code)
        end
        return code
    end
    return safe_exit(0)
end
