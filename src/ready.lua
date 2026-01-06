---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

---Wait for GameStateInit before initializing our keepsake list as it depends on it
modutil.mod.Path.Wrap("GameStateInit", function(base)
	local returnValue = base()
	InitPrioritizedKeepsakes()
	return returnValue
end)

--#region Set-Clear save first icon overrides

---Overrides SetSaveFirstIcon which display the prioritized keepsake icon
modutil.mod.Path.Override("SetSaveFirstIcon", function(screen, button)
	if not button then
		return
	end

	if not button["SavedKeepsakeIcon"] then
		local savedKeepsakeComponent = game.CreateScreenComponent({
			Name = "BlankObstacle",
			Group = "Combat_Menu_Overlay", -- Or Combat_Menu_TraitTray ?
			Animation = "AwardMenuItemSaveFirst",
			Alpha = 0.0,
			X = button.X,
			Y = button.Y,
		})
		table.insert(screen.Components, savedKeepsakeComponent)

		button["SavedKeepsakeIcon"] = savedKeepsakeComponent.Id
	end

	game.SetAlpha({ Id = button.SavedKeepsakeIcon, Fraction = 1.0, Duration = 0.2 })
end)

---Overrides ClearSaveFirstIcon which clears the prioritized keepsake icon
modutil.mod.Path.Override("ClearSaveFirstIcon", function(screen, button)
	if not button then
		return
	end
	game.SetAlpha({ Id = button.SavedKeepsakeIcon, Fraction = 0.0, Duration = 0.2 })
end)

--#endregion

local function SaveCallRestore(keepsake, callable, ...)
	local saved = GetGameSavedKeepsake()
	SetGameSavedKeepsake(keepsake)
	local returnValue = callable(...)
	SetGameSavedKeepsake(saved)

	return returnValue
end

-- Creates the prioritized keepsake icon components
modutil.mod.Path.Wrap("CreateKeepsakeIcon", function(base, screen, components, args)
	local traitName = args and args.UpgradeData and args.UpgradeData.Gift
	if not traitName then
		base(screen, components, args)
	end

	return SaveCallRestore(GetPrioritizedOrEmpty(traitName), base, screen, components, args)
end)

-- Sets up the button action bar inside keepsake screen
modutil.mod.Path.Wrap("KeepsakeScreenUpdateActionBar", function(base, screen, button)
	local traitName = button and button.TraitData and button.TraitData.Name
	if not traitName then
		return base(screen, button)
	end

	return SaveCallRestore(GetPrioritizedOrEmpty(traitName), base, screen, button)
end)

-- Gets called when (de)prioritizing a keepsake
modutil.mod.Path.Wrap("KeepsakeScreenSaveFirst", function(base, screen, button)
	local traitName = screen
		and screen.SelectedButton
		and screen.SelectedButton.Data
		and screen.SelectedButton.Data.Gift
	if not traitName then
		return base(screen, button)
	end

	local prioritized = GetPrioritizedOrEmpty(traitName)
	TogglePrioritized(traitName)

	return SaveCallRestore(prioritized, base, screen, button)
end)

modutil.mod.Path.Override("EquipLastAwardTrait", function(eventSource, hero)
	EquipRandomKeepsake(game.CurrentRun, hero)
	if not config.randomizeAtRunStart then
		SaveLastRandomKeepsake()
	end
end)

modutil.mod.Path.Wrap("ChooseStartingRoom", function(base, currentRun, args)
	if config.randomizeAtRunStart then
		EquipRandomKeepsake(currentRun)
		SaveLastRandomKeepsake()
	end

	return base(currentRun, args)
end)

modutil.mod.Path.Wrap("SpecialInteractChangeNextRunRNG", function(base, ...)
	local returnValue = base(...)

	EquipRandomKeepsake(game.CurrentRun)
	if not config.randomizeAtRunStart then
		SaveLastRandomKeepsake()
	end

	return returnValue
end)
