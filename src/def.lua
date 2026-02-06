---@meta SMarBe-Random_Starting_Keepsake
local public = {}

---Get the prioritized keepsakes
---@return string
function public.GetKeepsakes() end

---Set the prioritized keepsakes
---@param keepsakesStr string
function public.SetKeepsakes(keepsakesStr) end

---Enable always randomizing at run start, this overrides the settings
function public.EnableAlwaysRandomizeAtRunStart() end

return public
