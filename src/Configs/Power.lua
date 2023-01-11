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
    self.levels = data.levels

    for i, levelTable in ipairs(self.levels) do
        if levelTable.displayName then
            self.displayName = levelTable.displayName
        end
    end
end



return Power