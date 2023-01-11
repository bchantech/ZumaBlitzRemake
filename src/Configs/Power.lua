local class = require "com/class"

---@class Power
---@overload fun(data):Power
local Power = class:derive("Power")

local Profile = require("src/Profile")



---Initialize a new Power.
---@param data table Raw data parsed from `config/powers/*.json`.
---@param path string Path to the file. The file is not loaded here, but is used in error messages.
function Power:new(data, path)
    self.name = data.name
    self._path = path
    self.displayName = data.displayName
    self.type = data.type
end



function Power:isEquipped()
    for i, power in ipairs(_Game:getCurrentProfile().equippedPowers) do
        
    end
end



return Power