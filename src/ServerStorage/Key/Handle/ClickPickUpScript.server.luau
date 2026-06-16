local MeshPart = script.Parent
local ClickDetector = MeshPart:WaitForChild("ClickDetector")
local ToolContainer = MeshPart.Parent -- This is the 'Key' Tool object

-- Set how close the player needs to be to click it
ClickDetector.MaxActivationDistance = 6

local function onKeyClicked(player)
	-- 🛠️ CLEANED UP: Removed the typo line entirely!
	MeshPart.Anchored = false 

	-- Force the tool directly into the player's Backpack inventory
	ToolContainer.Parent = player.Backpack

	-- Safely destroy this script and the detector since it's now picked up
	ClickDetector:Destroy()
	script:Destroy()
end

ClickDetector.MouseClick:Connect(onKeyClicked)