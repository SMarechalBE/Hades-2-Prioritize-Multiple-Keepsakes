local config = {
	enabled = true,
	randomizeAtRunStart = true,
	prioritizedKeepsakes = "",
	previousRandomKeepsake = "",
}

local configDesc = {
	enabled = "Enable the mod",
	randomizeAtRunStart = "Randomize keepsake at run start if currently equipped keepsake is one of the favorites, otherwise when entering training room or at oath of the unseen (if unlocked)",
	prioritizedKeepsakes = "List of keepsakes to prioritize, separated by ','",
	previousRandomKeepsake = "Previous randomly generated keepsake",
}

return config, configDesc
