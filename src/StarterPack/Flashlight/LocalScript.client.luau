local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local Light = Handle:WaitForChild("SpotLight")

-- This runs on the server, meaning the monster CAN see it!
local function onActivated()
	-- Toggle the light on and off
	Light.Enabled = not Light.Enabled

	-- Sound effect toggle (optional, if your tool has sounds)
	local sound = Handle:FindFirstChild("Click") or Handle:FindFirstChild("SwitchSound")
	if sound then
		sound:Play()
	end
end

local function onUnequipped()
	-- Safety check: Always turn the light completely OFF if the player puts the tool away
	Light.Enabled = false
end

Tool.Activated:Connect(onActivated)
Tool.Unequipped:Connect(onUnequipped)