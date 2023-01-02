-- This is a default module file for OpenSMCE games.
-- You can override any, or all of the methods below.
-- To do so, copy this file to games/<game>/modules/ folder and start editing.
-- Keep in mind that more methods may be added, or existing changed in the future.
-- These script files will be automatically updated if needed by the engine.

-- All methods will be stored here.
local f = {}



-- ON MATCH METHODS
-- Parameters:
-- length (number) - How many spheres were destroyed.
-- comboLv (number) - A number of consecutive matches done by player.
-- chainLv (number) - A chain reaction level - how many matches were done in a row via magnetization.
-- comboBoost (boolean) - Whether the match was done by a player (a sphere was shot into).

-- If this method returns true, a coin will be spawned.
function f.coinSpawn(length, comboLv, chainLv, comboBoost)
  return length > 4 and math.random() < (length - 3) * 0.25
end

-- If this method returns true, a powerup will be spawned.
function f.powerupSpawn(length, comboLv, chainLv, comboBoost)
  return (chainLv == 1 and comboBoost and comboLv % 3 == 0) or chainLv % 3 == 0
end

-- This function returns parameters for Game:playSound() when matching. Used for sound robustness.
-- NOTE: Is gamehjh.lua even used in the game? Will be modifying this file in the meantime.
-- FORK-SPECIFIC CODE: The match sound is based off the chain (combo in Zuma) amount.
function f.matchSound(length, comboLv, chainLv, comboBoost)
  local soundID = math.min(chainLv+1, 5)
  return {
    name = "sound_events/sphere_destroy_" .. tostring(soundID) .. ".json",
    pitch = 1
  }
end

-- FORK-SPECIFIC CODE: Supplemental to f.matchSound() to emulate Zuma combo chime pitching
function f.chainSound(chainLv)
  return {
    name = "sound_events/sphere_destroy_chime.json",
    pitch = 1 + (0.1 * chainLv)
  }
end



-- Now we need to carry all functions that we've inserted over to the engine.
return f
