local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

print("[LOCAL TEST] Door Script Initialized!")

local DoorModel = Workspace:WaitForChild("LockedDoor")
local DoorPart = DoorModel:FindFirstChildWhichIsA("BasePart") 
local isUnlocked = false

task.spawn(function()
	while not isUnlocked do
		task.wait(0.3)
		
		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				
				local hasKey = character:FindFirstChild("Key") or player.Backpack:FindFirstChild("Key")
				
				if hasKey and DoorPart then
					local distance = (character.HumanoidRootPart.Position - DoorPart.Position).Magnitude
					
					if distance < 7 then
						isUnlocked = true
						hasKey:Destroy()
						
						for _, part in ipairs(DoorModel:GetChildren()) do
							if part:IsA("BasePart") then
								part.CanCollide = false
								part.Transparency = 0.8
							end
						end
						print("[LOCAL TEST] SUCCESS! Distance check passed. Door Unlocked!")
						break
					end
				end
			end
		end
	end
end)