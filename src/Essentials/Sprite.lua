local class = require "com.class"

---@class Sprite
---@overload fun(path):Sprite
local Sprite = class:derive("Sprite")

local Vec2 = require("src.Essentials.Vector2")
local Color = require("src.Essentials.Color")
local Image = require("src.Essentials.Image")



---Constructs a new Sprite.
---@param path string A path to the sprite file. OR it can be a raw sprite.
function Sprite:new(path)
	
	local data = {}
	
	if type(path) == "string" then
		self.path = path
		data = _LoadJson(path)
		if data.internal then
			self.img = Image(_ParsePath(data.path))
		else
			self.img = _Game.resourceManager:getImage(data.path)
		end
	else
		-- the path is a data file.
		data = path
		self.img = Image(path)
	end

	self.size = self.img.size
	self.frameSize = data.frame_size
	self.states = {}

	-- Default position to 0,0 and 1 frame if states is not defined
	if not data.states then
		data.states = {}
		data.states[1] = {pos = {x = 0, y = 0}, frames = {x = 1, y = 1}} 
	end

	for i, state in ipairs(data.states) do
		local s = {}
		s.frameCount = state.frames
		s.frames = {}
		for j = 1, state.frames.x do
			s.frames[j] = {}
			for k = 1, state.frames.y do
				local p = self.frameSize * (Vec2(j, k) - 1) + state.pos
				s.frames[j][k] = love.graphics.newQuad(p.x, p.y, self.frameSize.x, self.frameSize.y, self.size.x, self.size.y)
			end
		end
		self.states[i] = s
	end
end



---Returns a quad object for use in drawing functions.
---@param state integer The state ID of this sprite.
---@param frame Vector2|integer The sprite to be obtained.
---@return love.Quad
function Sprite:getFrame(state, frame)
	--print(self.frames[(frame.x - 1) % self.frameCount.x + 1][(frame.y - 1) % self.frameCount.y + 1])
	--for k1, v1 in pairs(self.frames) do
	--	for k2, v2 in pairs(v1) do print(k1, k2, v2) end
	--end
	local s = self.states[state]
	if s == nil then
		-- should a sprite attempt to get a non existent state attempt to use the data from the first state instead.
		print ("ERROR: Attempted to get non-existent state: " .. state .. " in file " .. self.path)
		s = self.states[1]
	end

	-- FORK-SPECIFIC CODE: if a number is detected in frame, this is assumed to be frame # (starting at 1)
	-- and we will convert to a vector instead.
	local vec2_frame = {x=0, y=0}
	if type(frame) == "number" then
		frame = math.floor(frame)
		frame = math.max(frame, 1) -- enforce min frame of 1
		frame = math.min(frame, s.frameCount.x * s.frameCount.y) -- max frame is the number of frames is the x*y grid

		vec2_frame.x = 1 + ((frame-1) % s.frameCount.x)
		vec2_frame.y = 1 + (math.floor((frame-1) / s.frameCount.x))
		vec2_frame.y = math.min(vec2_frame.y, s.frameCount.y) 
	else
		vec2_frame = frame
	end

	return s.frames[(vec2_frame.x - 1) % s.frameCount.x + 1][(vec2_frame.y - 1) % s.frameCount.y + 1]
end



---Draws this Sprite onto the screen.
---@param pos Vector2 The sprite position.
---@param align Vector2? The sprite alignment. `(0, 0)` is the top left corner. `(1, 1)` is the bottom right corner. `(0.5, 0.5)` is in the middle.
---@param state integer? The state ID to be drawn.
---@param frame Vector2? The sprite to be drawn.
---@param rot number? The sprite rotation in radians.
---@param color Color? The sprite color.
---@param alpha number? Sprite transparency. `0` is fully transparent. `1` is fully opaque.
---@param scale Vector2? The scale of this sprite.
---@param blendMode "none"|"alpha"|"screen"|"add"|"subtract"|"multiply"|"lighten"|"darken"? The blending mode to use.
function Sprite:draw(pos, align, state, frame, rot, color, alpha, scale, blendMode)
	align = align or Vec2()
	state = state or 1
	frame = frame or Vec2(1)
	rot = rot or 0
	color = color or Color()
	alpha = alpha or 1
    scale = scale or Vec2(1)
    blendMode = blendMode or "alpha"
    -- this is for convenience reasons so json files can use "none"
	-- instead of "alpha", but the option is there regardless
	if blendMode == "none" then
		blendMode = "alpha"
    end
	pos = _PosOnScreen(pos - (align * scale * self.frameSize):rotate(rot))
	if color.r then -- temporary chunk
		love.graphics.setColor(color.r, color.g, color.b, alpha)
	else
		love.graphics.setColor(table.unpack(color), alpha)
    end

	--[[
	local blendAlphaMode = "alphamultiply"
    local modesToPremultiply = { "add", "subtract", "multiply", "lighten", "darken" }
	for _,mode in pairs(modesToPremultiply) do
		if mode == blendMode then
			blendAlphaMode = "premultiplied"
		end
	end
	]]
	---@diagnostic disable-next-line: param-type-mismatch
    love.graphics.setBlendMode(blendMode)

	self.img:draw(self:getFrame(state, frame), pos.x, pos.y, rot, scale.x * _GetResolutionScale(), scale.y * _GetResolutionScale())
end



return Sprite
