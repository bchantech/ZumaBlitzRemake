local class = require "com.class"

---@class Replay
---@overload fun(data):Replay
local Replay = class:derive("Replay")

local json = require("com.json")

---Constructs an Replay object.
---@param data table The data to be read.
function Replay:new()
    self:reset()
end

--- load a encoded replay stream and convert to object format.
function Replay:load(data)  
    --print(data)
    local replay_body = love.data.decode("string", "base64", data)
    local replay_contents = love.data.decompress("string", "zlib", replay_body)
    self.replaydata = json.decode(replay_contents)
    self.replay_actions = #self.replaydata
    self.replay_loaded = true
end

--- Clear all replay data.
function Replay:reset()
    self.replaydata = {}
    self.replay_actions = 0
	self.replay_current = 1
    self.replay_loaded = false
end

--- Rewinds the current replay counter to one.
function Replay:rewind()
	self.replay_current = 1
end

--- Execute actions if next action over game time and advance the counter if the replay did not end yet
--- return angle, action (1 = shoot, 2 = swap)
--- if no action, then both values return nil
function Replay:advance(time)

    if self.replay_actions >= self.replay_current then
		local replay_time = self.replaydata[self.replay_current].time
		local replay_angle = self.replaydata[self.replay_current].angle or 0
		local replay_action = self.replaydata[self.replay_current].action or 1

		if math.abs(replay_time - time) < 0.0001 then
			if replay_action == 1 then
				self.replay_current = self.replay_current + 1
                return replay_angle, 1
			else
				self.replay_current = self.replay_current + 1
                return nil, 2
			end
		end
	end

    return nil, nil
end

--- Record a replay action. 
--- For fire ball, action doesn't need to be recorded.
function Replay:record(time, angle, action)
    if action == 1 then
        local b = {time = time, angle = angle}
        table.insert(self.replaydata,b)	
    elseif action == 2 then
        local b = {time = time, action = 2}
        table.insert(self.replaydata,b)	
    end
end

--- Save replay
--- This returns a string containing replay data rather than saving to a file
function Replay:save()
	local replay_compress = love.data.compress("data", "zlib",  json.encode(self.replaydata))
	local replay_body =  love.data.encode("string", "base64", replay_compress)
    return replay_body
end

return Replay
