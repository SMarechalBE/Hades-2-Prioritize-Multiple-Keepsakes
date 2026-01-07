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
---@param keepsake string?
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
			table.insert(keepsakes, keepsake)
		end
	end

	local prioCount = #keepsakes
	if prioCount == 0 then
		return exclude
	end

	return keepsakes[math.random(prioCount)]
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

---Get the currently equipped keepsake if applicable
--- This also has the side effect of resynchronizing game.GameState.LastAwardTrait
--- if it is not the currently equipped keepsake
---@return string? keepsake Optionally equipped
function GetEquippedKeepsake()
	local equippedKeepsake = game.GameState and game.GameState.LastAwardTrait
	if game.HeroHasTrait(equippedKeepsake) then
		return equippedKeepsake
	end

	-- Let's make sure game.GameState.LastAwardTrait isn't lying just in case
	local traits = game.CurrentRun and game.CurrentRun.Hero and game.CurrentRun.Hero.Traits
	if not traits then
		return
	end

	for _, traitData in ipairs(traits) do
		if traitData.Slot == "Keepsake" then
			modutil.mod.Print(
				"Something went wrong, game.GameState.LastAwardTrait is out of sync, let's restore its value for game integrity..."
			)
			if not game.GameState then
				game.GameState = {}
			end
			game.GameState["LastAwardTrait"] = traitData.Name

			return traitData.Name
		end
	end
end

---Unequip the current keepsake if applicable
---@return string? keepsake The unequipped keepsake if there was one
function UnequipCurrentKeepsake()
	local hero = game.CurrentRun.Hero
	if not hero then
		modutil.mod.Print("Can't equip random keepsake for nil hero")
		return
	end

	local keepsake = GetEquippedKeepsake()
	if keepsake then
		game.UnequipKeepsake(hero, keepsake)
	end

	return keepsake
end

---Unequip current keepsake and equip a random one, try to avoid the previous one if possible
function EquipRandomKeepsake()
	local hero = game.CurrentRun.Hero
	if not hero then
		modutil.mod.Print("Can't equip random keepsake for nil hero")
		return
	end

	UnequipCurrentKeepsake()
	local keepsake = GetRandomPrioritizedKeepsake(config.previousRandomKeepsake)

	SetGameSavedKeepsake(keepsake) -- update the saved keepsake for data integrity

	game.GameState.LastAwardTrait = keepsake
	game.EquipKeepsake(hero, game.GameState.LastAwardTrait, { FromLoot = true })
end
