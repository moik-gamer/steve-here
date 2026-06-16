local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")

print("[LOCAL TEST] Key Script Initialized!")

local floorKey = Workspace:WaitForChild("FloorKey", 5)

if floorKey then
	local cd = floorKey:WaitForChild("ClickDetector")
	cd.MouseClick:Connect(function(player)
		local template = ServerStorage:FindFirstChild("Key")
		if template then
			local clone = template:Clone()
			local handle = clone:FindFirstChild("Handle")
			
			if handle then
				handle.Anchored = false
				handle.CanCollide = false
				handle.Massless = true
				handle.Size = Vector3.new(1, 0.4, 1)
			end
			
			clone.Parent = player.Backpack
			floorKey:Destroy()
			print("[LOCAL TEST] Key successfully added to backpack!")
		end
	end)
end