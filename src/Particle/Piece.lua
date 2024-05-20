local class = require "com.class"

---@class ParticlePiece
---@overload fun(manager, spawner, data):ParticlePiece
local ParticlePiece = class:derive("ParticlePiece")

local Vec2 = require("src.Essentials.Vector2")
local Sprite = require("src.Essentials.Sprite")



function ParticlePiece:new(manager, spawner, data)
	self.manager = manager
	self.packet = spawner.packet
	self.spawner = spawner
	self.spawner.pieceCount = self.spawner.pieceCount + 1

	self.packetPos = self.packet.pos

	self.startPos = self.spawner.pos
	if not data.posRelative then
		self.startPos = self.spawner:getPos()
	end
	self.pos = self.startPos
	
	self.layer = self.spawner.layer



	self.speedMode = data.speedMode

	self.spawnScale = _ParseVec2(data.spawnScale) or Vec2()
	self.posAngle = math.random() * math.pi * 2
	local spawnRotVec = Vec2(1):rotate(self.posAngle)
	local spawnPos = spawnRotVec * self.spawnScale
	self.pos = self.pos + spawnPos

	if self.speedMode == "loose" then
		self.speed = _ParseVec2(data.speed) or Vec2()
	elseif self.speedMode == "radius" then
		self.speed = spawnRotVec * _ParseVec2(data.speed) or Vec2()
	elseif self.speedMode == "radius_linear" then
		self.speed = spawnRotVec * _ParseNumber(data.speed) or 0
	elseif self.speedMode == "circle" then
		self.speed = (_ParseNumber(data.speed) * math.pi / 180) or 0 -- convert degrees to radians
	else
		error("Unknown particle speed mode: " .. tostring(self.speedMode))
	end

	if self.speedMode == "circle" or self.speedMode == "radius_linear" then
		self.acceleration = _ParseNumber(data.acceleration) or 0
	else
		self.acceleration = _ParseVec2(data.acceleration) or Vec2()
	end

	self.lifespan = _ParseNumber(data.lifespan) -- nil if it lives indefinitely
	self.lifetime = self.lifespan
	self.time = 0

    self.sprite = _Game.resourceManager:getSprite(data.sprite)
	self.blendMode = data.blendMode

	-- initalize the starting frame count assuming a static frame or otherwise.

	self.animationSpeed = 30
	self.animationFrameCount = 1
	self.animationLoop = true
	self.animationFrameRandom = false

	if self.sprite then
		self.animationSpeed = self.sprite.animationSpeed or self.animationSpeed
		self.animationFrameCount = self.sprite.animationFrameCount or self.animationFrameCount
		if self.sprite.animationLoop ~= nil then self.animationLoop = self.sprite.animationLoop end
		self.animationFrameRandom = self.sprite.animationFrameRandom or self.animationFrameRandom
	end

	self.animationSpeed = data.animationSpeed or self.animationSpeed
	self.animationFrameCount = data.animationFrameCount or self.animationFrameCount
	if data.animationLoop ~= nil then self.animationLoop = data.animationLoop end
	self.animationFrameRandom = data.animationFrameRandom or self.animationFrameRandom

	-- force animationFrameCount to 1 if it's lower than that.
	self.animationFrameCount = math.max(1, self.animationFrameCount)

	self.fadeInPoint = data.fadeInPoint
	self.fadeOutPoint = data.fadeOutPoint
	self.posRelative = data.posRelative
	self.directionDeviation = false -- is switched to true after directionDeviationTime seconds (if that exists)
	self.directionDeviationTime = _ParseNumber(data.directionDeviationTime)
	self.directionDeviationSpeed = data.directionDeviationSpeed -- evaluated every frame

	self.animationFrame = self.animationFrameRandom and math.random(1, self.animationFrameCount) or 1

	self.colorPalette = data.colorPalette and _Game.resourceManager:getColorPalette(data.colorPalette)
	self.colorPaletteSpeed = data.colorPaletteSpeed

	self.delQueue = false
end

function ParticlePiece:update(dt)
	-- lifespan
	if self.lifetime then
		self.lifetime = self.lifetime - dt
		if self.lifetime <= 0 then self:destroy() end
	end
	self.time = self.time + dt
	if not self.directionDeviation and self.directionDeviationTime and self.time >= self.directionDeviationTime then
		self.directionDeviation = true
	end

	-- position stuff
	if self.directionDeviation then self.speed = self.speed:rotate(_ParseNumber(self.directionDeviationSpeed) * dt) end
	self.speed = self.speed + self.acceleration * dt
	if self.speedMode == "circle" then
		self.posAngle = self.posAngle + self.speed * dt
		self.pos = self.startPos + (self.spawnScale * Vec2(1):rotate(self.posAngle))
	else
		self.pos = self.pos + self.speed * dt
	end
	-- cache last packet position
	if self.packet then
		self.packetPos = self.packet.pos
	end

	-- animation
	self.animationFrame = self.animationFrame + self.animationSpeed * dt
	if self.animationFrame >= self.animationFrameCount + 1 then
		if self.animationLoop then self.animationFrame = self.animationFrame % self.animationFrameCount end
		--self:destroy()
	end

	-- detach when spawner/packet is gone
	if self.spawner and self.spawner.delQueue then
		self.spawner = nil
	end
	if self.packet and self.packet.delQueue then
		self.packet = nil
	end

	-- when living indefinitely and packet inexistent, destroy
	if not self.packet and not self.lifetime then
		self:destroy()
	end
end



function ParticlePiece:destroy()
	if self.delQueue then return end
	self.delQueue = true

	self.manager:destroyParticlePiece(self)
	if self.spawner then
		self.spawner.pieceCount = self.spawner.pieceCount - 1
	end
end



function ParticlePiece:getPos()
	if self.posRelative then
		return self.packetPos + self.pos
	else
		return self.pos
	end
end

function ParticlePiece:getColor()
	if self.colorPalette then
		local t = (self.colorPaletteSpeed and self.time * self.colorPaletteSpeed or 0)
		return self.colorPalette:getColor(t)
	end
end

function ParticlePiece:getAlpha()
	if not self.lifespan then
		return 1
	end

	if self.lifetime < self.lifespan * (1 - self.fadeOutPoint) then
		return self.lifetime / (self.lifespan * (1 - self.fadeOutPoint))
	elseif self.lifetime > self.lifespan * (1 - self.fadeInPoint) then
		return 1 - (self.lifetime - self.lifespan * (1 - self.fadeInPoint)) / (self.lifespan * self.fadeInPoint)
	else
		return 1
	end
end

function ParticlePiece:draw(layer)
	-- if it is not able to get a sprite skip altogether.
	if not self.sprite then return end

	local frame = math.min(math.floor(self.animationFrame), self.animationFrameCount)
	if self.layer == layer then
		self.sprite:draw(self:getPos(), Vec2(0.5), nil, frame, nil, self:getColor(), self:getAlpha(), nil, self.blendMode)
	end
end

return ParticlePiece
