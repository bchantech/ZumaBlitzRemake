local class = require "com.class"

---@class Map
---@overload fun(level, path, pathsBehavior, isDummy):Map
local Map = class:derive("Map")

local Vec2 = require("src.Essentials.Vector2")
local Sprite = require("src.Essentials.Sprite")

local Path = require("src.Path")



---Constructs a new Map.
---@param level Level The level which is tied to this Map.
---@param path string Path to the Map's folder.
---@param pathsBehavior table A table of Path Behaviors.
---@param isDummy boolean Whether this Map corresponds to a Dummy Level.
function Map:new(level, path, pathsBehavior, isDummy)
	self.level = level
	-- whether it's just a decorative map, if false then it's meant to be playable
	self.isDummy = isDummy

	self.paths = {}
	self.sprites = {}


	local data = _LoadJson(_ParsePath(path .. "/config.json"))
	self.name = data.name
	for i, spriteData in ipairs(data.sprites) do
		local spritePath = spriteData.path
		if spriteData.internal then
			spritePath = path .. "/" .. spritePath
		end
		table.insert(self.sprites, {pos = Vec2(spriteData.x, spriteData.y), sprite = Sprite(_ParsePath(spritePath)), background = spriteData.background})
	end
	for i, pathData in ipairs(data.paths) do
		-- Loop around the path behavior list if not sufficient enough.
		-- Useful if all paths should share the same behavior; you don't have to clone it.
		local pathBehavior = pathsBehavior[(i - 1) % #pathsBehavior + 1]
		table.insert(self.paths, Path(self, pathData, pathBehavior))
	end
    self.shooter = data.shooter
    self.targetPoints = data.targetPoints
	
	-- FORK-SPECIFIC CODE:
	-- Skulls. SPRITES ARE HARDCODED, DE-HARDCODE FIRST AND ALLOW FOR
    -- CUSTOMIZATION BY THE MODDER IF THIS IS TO BE IMPLEMENTED TO UPSTREAM.
	self.skullHoleSprite = _Game.resourceManager:getSprite("sprites/game/skull_hole.json")
	self.skullMaskSprite = _Game.resourceManager:getSprite("sprites/game/skull_mask.json")
	self.skullFrameSprite = _Game.resourceManager:getSprite("sprites/game/skull_frame.json")
	self.skullTopSprite = _Game.resourceManager:getSprite("sprites/game/skull_top.json")
	self.skullBottomSprite = _Game.resourceManager:getSprite("sprites/game/skull_bottom.json")
	self.skullMaskShader = love.graphics.newShader[[
		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
			if (Texel(texture, texture_coords).rgb == vec3(0.0)) {
				// a discarded pixel wont be applied as the stencil.
				discard;
			}
			return vec4(1.0);
		}
		]]

    self.skullPoints = {}
    for _, path in pairs(self.paths) do
		local lastPoint = path.nodes[#path.nodes].pos
        table.insert(self.skullPoints, Vec2.round(lastPoint))
    end
end



---Updates this Map.
---@param dt number Delta time in seconds.
function Map:update(dt)
	for i, path in ipairs(self.paths) do
		path:update(dt)
	end
end



---Returns the ID of a given Path, or `nil` if not found.
---@param path Path The Path of which ID is to be obtained.
---@return integer|nil
function Map:getPathID(path)
	for i, pathT in ipairs(self.paths) do
		if pathT == path then
			return i
		end
	end
end



---Draws this Map.
function Map:draw()
	-- Background
	for i, sprite in ipairs(self.sprites) do
		if sprite.background then
			sprite.sprite:draw(sprite.pos)
		end
	end

	-- Objects drawn before hidden spheres (background cheat mode)
	if _Debug.e then
		for i, sprite in ipairs(self.sprites) do
			if not sprite.background then
				sprite.sprite:draw(sprite.pos)
			end
		end
	end

	-- Draw hidden spheres and other hidden path stuff
	for x = 1, 2 do
		for i, path in ipairs(self.paths) do
			for sphereID, sphere in pairs(_Game.configManager.spheres) do
				path:drawSpheres(sphereID, true, x == 1)
			end
			path:draw(true)
		end
	end

	-- Objects that will be drown when the BCM is off
    if not _Debug.e then
        for i, sprite in ipairs(self.sprites) do
            if not sprite.background then
                sprite.sprite:draw(sprite.pos)
            end
        end
    end
	
	-- FORK-SPECIFIC CODE: skull rendering goes here
	-- i took this from the love2d page is this a dirty way to do it
	for i, pos in pairs(self.skullPoints) do
		self.skullHoleSprite:draw(pos, Vec2(0.5,0.5))
		love.graphics.stencil(function()
			love.graphics.setShader(self.skullMaskShader)
			self.skullMaskSprite:draw(pos, Vec2(0.5,0.5))
			love.graphics.setShader()
		end, "replace", 1)
        love.graphics.setStencilTest("greater", 0)

		local skullTopPos = Vec2(pos.x, (pos.y-3) - (self.paths[i]:getDangerProgress()*20))
        local skullBotPos = Vec2(pos.x, pos.y+10)
		
		self.skullTopSprite:draw(skullTopPos, Vec2(0.5,0.5))
        self.skullBottomSprite:draw(skullBotPos, Vec2(0.5, 0.5))
		
        love.graphics.setStencilTest()
		self.skullFrameSprite:draw(pos, Vec2(0.5,0.5))
	end
	-- END FORK-SPECIFIC CODE
end



---Draws spheres on this map.
function Map:drawSpheres()
	for x = 1, 2 do
		for i, path in ipairs(self.paths) do
			for sphereID, sphere in pairs(_Game.configManager.spheres) do
				path:drawSpheres(sphereID, false, x == 1)
			end
			path:draw(false)
		end
	end
end



---Serializes the Map's data to be saved.
---@return table
function Map:serialize()
	local t = {}
	for i, path in ipairs(self.paths) do
		table.insert(t, path:serialize())
	end
	return t
end



---Deserializes the Map's data.
---@param t table The data to be loaded.
function Map:deserialize(t)
	for i, path in ipairs(t) do
		self.paths[i]:deserialize(path)
	end
end



return Map
