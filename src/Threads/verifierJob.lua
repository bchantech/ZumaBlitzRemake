-- This is an example thread file.
-- It throws some garbage in the console and then returns the result of adding two numbers.
-- Example usage:
-- _ThreadManager:startJob("test", {a = 2, b = 5}, function(result) print("He finished!!! And the result is " .. tostring(result.result) .. "!") end)

-- Get the data from ThreadManager and connect to a unique channel provided by it.
local outID, data = ...
local out = love.thread.getChannel(outID)

print(string.format("begin %s", data.id))

-- Do some long and time expensive stuff.
for i = 1, 1000000000 do
    --print(i)
end

-- As I've found out, globals are not shared between threads.
--_Test = _Test and _Test + 1 or 1

-- Prepare data for returning.
local outData = {
    id = data.id,
    -- The random value will be always the same.
    result = math.random(10000)
}

-- Return data.
out:push(outData)