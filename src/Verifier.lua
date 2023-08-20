local class = require "com.class"

---@class Verifier
---@overload fun():Verifier
local Verifier = class:derive("Verifier")

-- Place your imports here
local Vec2 = require("src.Essentials.Vector2")



---Constructs a new Verifier.
---An instance of this class can sit in the `_Game` field. In that case, the program runs in verifier mode.
---This is designed to use in Cosmic Crash servers.
---This class coordinates the whole verifying process: receives data from a given socket, launches verifier job threads via ThreadManager,
---and sends back the results into another socket.
---
---Right now, this is heavily work in progress. Lots of stuff will be happening here!
function Verifier:new()
	self.nativeResolution = Vec2(800, 600)

    self.TEXT = [[
    This is a game verifier test for a new game called Cosmic Crash.
    
    Verification requests are listened to on port 5303.
    Verification results are sent back on port 5304.
    They will also appear locally on the right side.
    
    Press Z to crash the verifier
    Press X to hang the verifier
    Press C to clear the list
    (none of that works lol)
    ]]

    self.nextJob = 1
end



---Updates this Verifier.
---@param dt number Time delta in seconds.
function Verifier:update(dt)
    _ThreadManager:startJob("verifierJob", {id = self.nextJob}, self.onJobFinished, self)
    self.nextJob = self.nextJob + 1
end



---Callback function called when the verifier job finishes.
---@param data table Verification result data.
function Verifier:onJobFinished(data)
    print(string.format("end %s: got %s", data.id, data.result))
end



---Draws Verifier-related stuff.
---Normally this will never execute, as verifiers are headless and command-line only (see conf.lua for details).
function Verifier:draw()
	love.graphics.print(self.TEXT, 50, 100)

	love.graphics.print("Verification Results", 500, 100)
	love.graphics.print("Game ID", 500, 130)
	love.graphics.print("Score In", 560, 130)
	love.graphics.print("Score Out", 660, 130)
end



---Returns the native resolution of the Verifier, which is always 800 by 600.
---@return Vector2
function Verifier:getNativeResolution()
	return self.nativeResolution
end

--- Useless callback but it needs to be here.
function Verifier:mousepressed(x, y, button) end

--- Useless callback but it needs to be here.
function Verifier:mousereleased(x, y, button) end

--- Useless callback but it needs to be here.
function Verifier:mousemoved(x, y) end

--- Useless callback but it needs to be here.
function Verifier:wheelmoved(x, y) end

--- Useless callback but it needs to be here.
function Verifier:keypressed(key) end

--- Useless callback but it needs to be here.
function Verifier:keyreleased(key) end

--- Useless callback but it needs to be here.
function Verifier:textinput(t) end



return Verifier