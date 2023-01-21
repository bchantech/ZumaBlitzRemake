local class = require "com/class"

---@class Power
---@overload fun(data):Power
local Power = class:derive("Power")

local Profile = require("src/Profile")



---Initialize a new Power.
---@param data table Raw data parsed from `config/powers/*.json`.
---@param path string Path to the file. The file is not loaded here, but is used in error messages.
function Power:new(data, path)
    self._path = path
    self._name = nil -- Only used for self-reference; assigned in ConfigManager.lua
    self.displayName = data.displayName
    self.type = data.type
    self.levels = data.levels
    self.maxLevel = #self.levels
    self.currentLevel = nil -- Assigned in Power:updateCurrentLevel()
end



---Updates the currentLevel value.
function Power:updateCurrentLevel()
    local profile = _Game:getCurrentProfile()
    self.currentLevel = (profile and profile:getPowerLevel(self._name)) or 1
end



---Returns the leveled display name of this Power.
---If value is nil, returns the current level.
---@param value number|"current"|nil
---@return string
function Power:getLeveledDisplayName(value)
    if value == "current" or value == nil then
        value = _Game:getCurrentProfile():getPowerLevel(self._name)
    end
    local romanNums = { "I", "II", "III" }
    if self.levels and self.levels[value] and self.levels[value].displayName then
        return self.levels[value].displayName
    else
        return self.displayName..string.format(" %s", romanNums[value])
    end
end



function Power:isMaxLevel()
    return _Game:getCurrentProfile():getPowerLevel(self._name) == self.maxLevel
end



---@return table
function Power:getCurrentLevelData()
    return self.levels[self.currentLevel]
end



return Power