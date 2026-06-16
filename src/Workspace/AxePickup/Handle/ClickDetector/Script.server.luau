local scriptInsideDetector = script
local clickDetector = scriptInsideDetector.Parent
local physicalPart = clickDetector.Parent
local worldModel = physicalPart.Parent -- Targets the main "AxePickup" model container
local ServerStorage = game:GetService("ServerStorage")

local AXE_NAME = "Axe" 

clickDetector.MouseClick:Connect(function(player)
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character

	if backpack and character then
		local hasInBackpack = backpack:FindFirstChild(AXE_NAME)
		local hasEquipped = character:FindFirstChild(AXE_NAME)

		if not hasInBackpack and not hasEquipped then
			local originalAxe = ServerStorage:FindFirstChild(AXE_NAME)

			if originalAxe then
				local axeClone = originalAxe:Clone()
				axeClone.Parent = backpack

				-- Smoothly deletes the entire world model asset
				worldModel:Destroy()
			else
				warn("Error: Could not find the functional tool named '" .. AXE_NAME .. "' inside ServerStorage!")
			end
		end
	end
end)
