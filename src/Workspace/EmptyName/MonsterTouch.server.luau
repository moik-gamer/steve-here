local Monster = script.Parent
local JumpscareGui = Monster:WaitForChild("JumpscareGui")
local ScreamSound = Monster:WaitForChild("ScreamSound") -- Reference our new sound

-- Track players to prevent the jumpscare from triggering multiple times at once
local cooldowns = {}

local function onTouch(hit)
	local character = hit.Parent
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local player = game:GetService("Players"):GetPlayerFromCharacter(character)

	if player and humanoid and humanoid.Health > 0 then
		if cooldowns[player] then return end
		cooldowns[player] = true

		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			-- 1. Play the terrifying scream audio instantly
			ScreamSound:Play()

			-- 2. Clone the jumpscare image onto their screen
			local guiClone = JumpscareGui:Clone()
			guiClone.Parent = playerGui

			-- 3. Let the scare play out for exactly 1 second
			task.wait(1)

			-- 4. Clean up the image and eliminate the player
			guiClone:Destroy()
			humanoid.Health = 0 
		end

		-- Cooldown reset so the monster can target them again after respawn
		task.wait(3)
		cooldowns[player] = nil
	end
end

-- Connect the touch function to all physical parts of the monster
for _, part in ipairs(Monster:GetChildren()) do
	if part:IsA("BasePart") then
		part.Touched:Connect(onTouch)
	end
end