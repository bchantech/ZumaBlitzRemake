local class = require "com/class"
local ConfigManager = class:derive("ConfigManager")

local CollectibleGeneratorManager = require("src/CollectibleGenerator/Manager")

function ConfigManager:new()
	self.config = loadJson(parsePath("config.json"))

	self.loadList = loadJson(parsePath("config/loadlist.json"))
	local resourceTypes = {"images", "sprites", "sounds", "sound_events", "music", "particles", "fonts"}
	self.resourceList = {}
	for i, type in ipairs(resourceTypes) do
		self.resourceList[type] = {}
		for j, path in ipairs(getDirListing(parsePath(type), "file", nil, true)) do
			local name = type .. "/" .. path
			local ok = true
			if self.loadList[type] then
				-- Forbid loading the same resource twice.
				for k, path2 in ipairs(self.loadList[type]) do
					if name == path2 then
						ok = false
						break
					end
				end
			end
			if ok then
				table.insert(self.resourceList[type], name)
			end
		end
	end

	self.gameplay = loadJson(parsePath("config/gameplay.json"))
	self.highscores = loadJson(parsePath("config/highscores.json"))
	self.hudLayerOrder = loadJson(parsePath("config/hud_layer_order.json"))
	self.music = loadJson(parsePath("config/music.json"))
	self.powerups = loadJson(parsePath("config/powerups.json"))

	self.collectibleGeneratorManager = CollectibleGeneratorManager()

	self.spheres = {}
	local configSpheres = loadJson(parsePath("config/spheres.json"))
	for k, v in pairs(configSpheres) do
		self.spheres[tonumber(k)] = v
	end

	self.levels = {}
	self.maps = {}
	for i, levelConfig in ipairs(self.config.levels) do
		local level = loadJson(parsePath(levelConfig.path))
		self.levels[i] = level
		if not self.maps[level.map] then
			self.maps[level.map] = loadJson(parsePath("maps/" .. level.map .. "/config.json"))
		end
	end
end

return ConfigManager
