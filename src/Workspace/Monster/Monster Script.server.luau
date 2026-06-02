local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")

local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")
local rootPart = npc:WaitForChild("HumanoidRootPart")

-- Set the NPC's walkspeed to be slightly slower than the default 16
humanoid.WalkSpeed = 15

-- Function to locate the closest living player
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = math.huge -- Start at infinity

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
			-- Ensure the player is actually alive before chasing
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

-- Main chasing loop
while task.wait(0.01) do -- Recalculates the target/path every half second
	local targetPlayer = getClosestPlayer()

	if targetPlayer and targetPlayer.Character then
		local targetRoot = targetPlayer.Character.HumanoidRootPart

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

			-- Move to the first few waypoints before checking again
			-- Index 1 is usually where the NPC stands, so we target index 2 or 3
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
	else
		-- Idle behavior if no players are around or alive
		humanoid:MoveTo(rootPart.Position)
	end
end
