---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

---Get game data saved keepsake
---@return string
function GetGameSavedKeepsake()
	return game.GameState and game.GameState.SaveFirstKeepsakeName or ""
end

---Set game data saved keepsake
---@param keepsake string?
function SetGameSavedKeepsake(keepsake)
	if game.GameState then
		game.GameState.SaveFirstKeepsakeName = keepsake
	end
end

---Save last randomized keepsake
function SaveLastRandomKeepsake()
	config.previousRandomKeepsake = game.GameState and game.GameState.LastAwardTrait or ""
end

---Get last randomized keepsake
---@return string keepsake
function GetLastRandomKeepsake()
	return config.previousRandomKeepsake
end

---Check if a given keepsake is prioritized
---@param keepsake string
---@return boolean
function IsPrioritized(keepsake)
	return config.keepsakes[keepsake] or false
end

---Returns the passed keepsake if prioritized otherwise an empty string
---@param keepsake string
---@return string
function GetPrioritizedOrEmpty(keepsake)
	return IsPrioritized(keepsake) and keepsake or ""
end

---Add keepsake to prioritized keepsakes
---@param keepsake string
function AddPrioritized(keepsake)
	config.keepsakes[keepsake] = true
end

---Toggle prioritized value for given keepsake
---@param keepsake string
function TogglePrioritized(keepsake)
	config.keepsakes[keepsake] = not IsPrioritized(keepsake)
end

---Get the number of prioritized keepsakes
---@return integer
function GetPrioritizedCount()
	local count = 0

	if config.keepsakes and game.TableLength(config.keepsakes) > 0 then
		for _, prioritized in pairs(config.keepsakes) do
			if prioritized then
				count = count + 1
			end
		end
	end

	return count
end

---Get a random value from the prioritized keepsakes.
---@param exclude string? Exclude a keepsake from the possible values
---@return string? keepsake =nil if there are no prioritized keepsake, =exclude if it was the only prioritized, otherwise random
function GetRandomPrioritizedKeepsake(exclude)
	if GetPrioritizedCount() == 0 then
		return nil
	end

	exclude = exclude or ""

	local keepsakes = {}
	for keepsake, prioritized in pairs(config.keepsakes) do
		if prioritized and keepsake ~= exclude then
			keepsakes[keepsake] = true
		end
	end

	if game.TableLength(keepsakes) == 0 then
		return exclude
	end

	return game.GetRandomKey(keepsakes)
end

---Initialize prioritized keepsakes equals to the currently saved one if empty
function InitPrioritizedKeepsakes()
	if GetPrioritizedCount() > 0 then
		return
	end

	local savedKeepsake = GetGameSavedKeepsake()
	if savedKeepsake then
		AddPrioritized(savedKeepsake)
	end
end

function EquipRandomKeepsake(currentRun, hero)
	if not currentRun then
		return
	end

	local currentHero = hero or currentRun.Hero
	if not currentHero then
		modutil.mod.Print("Can't equip random keepsake for nil hero")
		return
	end

	local equippedKeepsake = game.GameState and game.GameState.LastAwardTrait
	if equippedKeepsake and game.HeroHasTrait(equippedKeepsake) then
		if not IsPrioritized(equippedKeepsake) then
			return -- Don't draw a random keepsake if the player decided to override one of the prioritized
		else
			game.UnequipKeepsake(currentHero, equippedKeepsake)
		end
	end

	SetGameSavedKeepsake(GetRandomPrioritizedKeepsake(config.previousRandomKeepsake))
	game.GameState.LastAwardTrait = GetGameSavedKeepsake()

	game.EquipKeepsake(currentHero, game.GameState.LastAwardTrait, { FromLoot = true })
end
