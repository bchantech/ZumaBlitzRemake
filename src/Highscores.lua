local class = require "com.class"

---Handles the Game's leaderboard.
---@class Highscores
---@overload fun(data):Highscores
local Highscores = class:derive("Highscores")



---Constructs a new Highscores object.
---@param data table? Data to be loaded.
function Highscores:new(data, online)
	self.data = data
	self.config = _Game.configManager.highscores

	-- default if not found
	if not self.data then self:reset() end

	if online then self:load() end
end



---Resets the leaderboard to default values.
function Highscores:reset()
	_Log:printt("Highscores", "Resetting Highscores...")

	self.data = {entries = {}}
	for i = 1, self.config.size do
		local def = self.config.defaultScores[i]
		self.data.entries[i] = {
			name = def.name,
			score = def.score,
			level = def.level
		}
	end
end


---Load the leaderboard based on the json output.

function Highscores:load()
	-- if there is no leaderboard data or is in error, return
	if not _LEADERBOARD_DATA then return end
	
	local data = _LEADERBOARD_DATA

	self.data = {entries = {}}
	for i = 1, #data.players do
		local def = data.players[i]
		self.data.entries[i] = {
			name = def.name,
			score = tonumber(def.score)
		}
		
		print ("score is type " .. type(self.data.entries[i].score))
		print (i)
	end
end



---Returns a specified entry from the leaderboard.
---@param n integer An entry index.
---@return table
function Highscores:getEntry(n)
	return self.data.entries[n]
end

---Returns a specified entry from the leaderboard. Returns a pair of strings conditing name and score.
---@param n integer An entry index.
---@return string, string
function Highscores:getEntryDisplay(n)
	if self.data.entries[n] then
		return self.data.entries[n].name, self.data.entries[n].score
	else
		return " ", " "
	end
end

---Returns a hypothetical position a player would get with given score, or `nil` if it does not qualify.
---@param score integer The score to be considered.
---@return integer|nil
function Highscores:getPosition(score)
	-- nil if it does not qualify
	local leaderboard_size = math.min(#self.data.entries, self.config.size)

	for i = leaderboard_size, 1, -1 do
		local entry = self:getEntry(i)
		if score <= entry.score then
			if i == leaderboard_size then
				-- We've hit the end of the highscore table, better luck next time!
				return nil
			else
				return i + 1
			end
		end
	end
	return 1
end



---Stores a given Profile's progress into a specified position of the leaderboard.
---That position and all entries below it are moved down by one space.
---@param profile Profile The profile to be stored.
---@param pos integer The position to be changed.
---@return nil
function Highscores:storeProfile(profile, pos)
	for i = self.config.size - 1, pos, -1 do
		-- everyone who is lower than the new highscore goes down
		self.data.entries[i + 1] = self:getEntry(i)
	end
	self.data.entries[pos] = {name = profile.name, score = profile:getScore(), level = profile:getLevelName()}
end



return Highscores
