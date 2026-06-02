local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")

local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")
local rootPart = npc:WaitForChild("HumanoidRootPart")

-- Speed settings
local CHASE_SPEED = 15 -- Speed when player is facing away
local FREEZE_SPEED = 0 -- Speed when player looks at the monster

humanoid.WalkSpeed = CHASE_SPEED

-- Function to locate the closest living player
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
			if character.Humanoid.Health > 0 then
				local distance = (rootPart.Position - character.HumanoidRootPart.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = player
				end
			end
		end
	end
	return closestPlayer
end

-- Function to check if the target player is looking at the monster
local function isPlayerWatching(targetPlayer)
	local character = targetPlayer.Character
	if not character then return false end

	-- Get the direction the player is facing
	local playerLookDirection = character.HumanoidRootPart.CFrame.LookVector

	-- Get the direction from the player straight to the monster
	local directionToMonster = (rootPart.Position - character.HumanoidRootPart.Position).Unit

	-- Use the Dot Product to calculate alignment (-1 to 1)
	local dotProduct = playerLookDirection:Dot(directionToMonster)

	-- 0.5 creates a wide, realistic 60-degree viewing cone. 
	-- If the dotProduct is higher than this, the monster is on their screen.
	if dotProduct > 0.5 then
		return true
	end

	return false
end

-- Main behavior loop
while task.wait(0.01) do 
	local targetPlayer = getClosestPlayer()

	if targetPlayer and targetPlayer.Character then
		local targetRoot = targetPlayer.Character.HumanoidRootPart

		-- Check if the player is looking at the monster
		if isPlayerWatching(targetPlayer) then
			-- FREEZE: The player sees it! Stop moving immediately.
			humanoid.WalkSpeed = FREEZE_SPEED
			humanoid:MoveTo(rootPart.Position) -- Forces the NPC to stop its current path step
		else
			-- CHASE: The player is looking away! Hunt them down.
			humanoid.WalkSpeed = CHASE_SPEED

			-- Create a path to navigate obstacles cleanly
			local path = PathfindingService:CreatePath({
				AgentRadius = 2,
				AgentHeight = 5,
				AgentCanJump = true
			})

			-- Compute the path from the NPC to the player
			path:ComputeAsync(rootPart.Position, targetRoot.Position)

			if path.Status == Enum.PathStatus.Success then
				local waypoints = path:GetWaypoints()

				if waypoints[2] then
					humanoid:MoveTo(waypoints[2].Position)

					-- Handle jumping if a waypoint requires it
					if waypoints[2].Action == Enum.PathWaypointAction.Jump then
						humanoid.Jump = true
					end
				end
			else
				-- Fallback: If pathfinding fails, directly move toward the player
				humanoid:MoveTo(targetRoot.Position)
			end
		end
	else
		-- Idle behavior if no players are around or alive
		humanoid.WalkSpeed = CHASE_SPEED
		humanoid:MoveTo(rootPart.Position)
	end
end