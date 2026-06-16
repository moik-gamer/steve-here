local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")

print("[Key System] Centralized Key Script Initialized!")
print("!!! VS CODE IS ALIVE !!!")
-- Wait up to 5 seconds for the floor key to exist in the workspace
local floorKey = Workspace:WaitForChild("FloorKey", 5)

if floorKey then
	local clickDetector = floorKey:WaitForChild("ClickDetector", 5)
	
	if clickDetector then
		print("[Key System] ClickDetector successfully found and hooked!")
		clickDetector.MaxActivationDistance = 6
		
		-- Connect the mouse click event
		clickDetector.MouseClick:Connect(function(player)
			print("[Key System] Click detected from player: " .. player.Name)
			
			-- Pull the fresh, unanchored tool template from ServerStorage
			local keyTemplate = ServerStorage:FindFirstChild("Key")
			if keyTemplate then
				local keyClone = keyTemplate:Clone()
				keyClone.Parent = player.Backpack -- Put it right in their inventory bar
				print("[Key System] Key tool cloned safely to backpack.")
				
				floorKey:Destroy() -- Vaporize the decoration key on the floor
			else
				warn("[Key System] ERROR: Key template missing from ServerStorage! Check your naming.")
			end
		end)
	else
		warn("[Key System] ERROR: ClickDetector was not found inside FloorKey!")
	end
else
	warn("[Key System] ERROR: FloorKey part could not be found in Workspace!")
end