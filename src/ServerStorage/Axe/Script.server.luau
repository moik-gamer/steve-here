local tool = script.Parent
local CollectionService = game:GetService("CollectionService")

-- Configuration
local DAMAGE_DISTANCE = 8 -- How close the player must be to the boards (in studs)
local ATTACK_COOLDOWN = 1  -- How many seconds the player must wait between swings

local isSwinging = false

tool.Activated:Connect(function()
	-- Prevent spam clicking
	if isSwinging then return end

	local character = tool.Parent
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	-- Verify player is alive and valid
	if not humanoid or not rootPart or humanoid.Health <= 0 then 
		return 
	end

	-- Start attack cooldown
	isSwinging = true

	-- OPTIONAL: If you add an animation track later, play it here:
	-- local animTrack = humanoid:LoadAnimation(tool.AttackAnimation)
	-- animTrack:Play()

	-- Find all tagged models in the game workspace
	local boards = CollectionService:GetTagged("BreakableBoard")

	for _, board in ipairs(boards) do
		-- Verify the tagged object is a Model (like your "Wooden Boards" model)
		if board:IsA("Model") then
			-- Automatically find the physical center position of the model
			local modelPosition = board:GetPivot().Position

			-- Calculate distance between the player and the model center
			local distance = (rootPart.Position - modelPosition).Magnitude

			if distance <= DAMAGE_DISTANCE then
				-- OPTIONAL: Play a sound effect if one is inside the model
				-- local sound = board:FindFirstChild("BreakSound")
				-- if sound then sound:Play() end

				-- Permanently destroy the entire model container and its parts
				board:Destroy()
			end
		end
	end

	-- Wait for the cooldown to finish before letting them swing again
	task.wait(ATTACK_COOLDOWN)
	isSwinging = false
end)
