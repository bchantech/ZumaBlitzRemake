local class = require "com/class"

---@class FoodItem
---@overload fun(data, path):FoodItem
local FoodItem = class:derive("FoodItem")

-- Place your imports here



function FoodItem:new(data, path)
    self._path = path
    self._name = nil -- Only used for self-reference; assigned in ConfigManager.lua
    self.displayName = data.displayName
    self.sprite = data.sprite
    self.price = data.price or 10000
    self.variants = data.variants
    self.variantBase = nil
    self.effects = data.effects

    for _, v in pairs({ "displayName", "sprite", "effects" }) do
        if not self[v] then
            error(string.format("[FoodItem] %s: missing required value \"%s\"", v))
        end
    end
    if type(data.effects) ~= "table" then
        error(string.format("[FoodItem] %s: invalid value for \"powers\" (must be table)", self._path))
    end
end



return FoodItem