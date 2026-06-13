local MonsterScript = {}

-- 🛠️ STEP 1: IMPORT THE ANIMATION SYSTEM AT THE VERY TOP
local MonsterAnimate = require(game:GetService("ServerScriptService").MonsterModuleScripts.MonsterAnimate)

function MonsterScript.StartLogic(Monster)
	local PathfindingService = game:GetService("PathfindingService")
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")

	local humanoid = Monster:WaitForChild("Humanoid")
	local rootPart = Monster:WaitForChild("HumanoidRootPart")

	-- 🛠️ STEP 2: TRIGGER THE ANIMATIONS RIGHT HERE AS SOON AS THE RIG LOADS
	MonsterAnimate.StartLogic(Monster)

	local JumpscareGui = Monster:WaitForChild("JumpscareGui")
	local ScreamSound = Monster:WaitForChild("ScreamSound")

	--  Find your custom monster spawn part safely
	local monsterSpawn = Workspace:WaitForChild("MonsterSpawn")

	-- Speed & Damage settings
	local CHASE_SPEED = 15 
	local FREEZE_SPEED = 0 
	local DAMAGE_AMOUNT = 30

	local activePlayers = {}
	local isTeleporting = false -- Prevents pathfinding from running during the jumpscare sequence

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

		local playerLookDirection = character.HumanoidRootPart.CFrame.LookVector
		local directionToMonster = (rootPart.Position - character.HumanoidRootPart.Position).Unit
		local dotProduct = playerLookDirection:Dot(directionToMonster)

		if dotProduct > 0.5 then
			return true
		end

		return false
	end

	-- Damage handler linked directly to death event
	local function onTouch(hit)
		if isTeleporting then return end -- Don't hit players while reset is happening

		local character = hit.Parent
		if not character then return end

		local playerHumanoid = character:FindFirstChildOfClass("Humanoid")
		local player = Players:GetPlayerFromCharacter(character)

		if player and playerHumanoid and playerHumanoid.Health > 0 and not activePlayers[player] then
			activePlayers[player] = true

			local deathConnection
			deathConnection = playerHumanoid.Died:Connect(function()
				isTeleporting = true -- Pause the pathfinding loop
				humanoid.WalkSpeed = FREEZE_SPEED
				humanoid:MoveTo(rootPart.Position) -- Stop instantly

				local playerGui = player:FindFirstChild("PlayerGui")
				if playerGui then
					ScreamSound:Play()
					local guiClone = JumpscareGui:Clone()
					guiClone.Parent = playerGui
					task.wait(1.5)
					guiClone:Destroy()
				end

				-- Teleport back safely
				rootPart.CFrame = monsterSpawn.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.1) -- Give physics a brief frame to settle

				-- Reset states so chasing can resume cleanly
				isTeleporting = false
				humanoid.WalkSpeed = CHASE_SPEED

				if deathConnection then deathConnection:Disconnect() end
				activePlayers[player] = nil
			end)

			playerHumanoid:TakeDamage(DAMAGE_AMOUNT)

			task.wait(1)
			if playerHumanoid.Health > 0 then
				if deathConnection then deathConnection:Disconnect() end
				activePlayers[player] = nil
			end
		end
	end

	-- Connect the touch function to all physical parts of the monster
	for _, part in ipairs(Monster:GetChildren()) do
		if part:IsA("BasePart") then
			part.Touched:Connect(onTouch)
		end
	end

	-- Main behavior loop
	while task.wait(0.05) do -- Slightly increased wait time to drastically improve performance/reliability
		-- Skip path calculations if the monster is currently resetting to spawn
		if not isTeleporting then 
			local targetPlayer = getClosestPlayer()

			if targetPlayer and targetPlayer.Character then
				local targetRoot = targetPlayer.Character.HumanoidRootPart

				if isPlayerWatching(targetPlayer) then
					-- FREEZE: The player sees it! Stop moving immediately.
					humanoid.WalkSpeed = FREEZE_SPEED
					humanoid:MoveTo(rootPart.Position) 
				else
					-- CHASE: The player is looking away! Hunt them down.
					humanoid.WalkSpeed = CHASE_SPEED

					local path = PathfindingService:CreatePath({
						AgentRadius = 2,
						AgentHeight = 5,
						AgentCanJump = true
					})

					path:ComputeAsync(rootPart.Position, targetRoot.Position)

					if path.Status == Enum.PathStatus.Success then
						local waypoints = path:GetWaypoints()

						if waypoints[2] then
							humanoid:MoveTo(waypoints[2].Position)

							if waypoints[2].Action == Enum.PathWaypointAction.Jump then
								humanoid.Jump = true
							end
						end
					else
						humanoid:MoveTo(targetRoot.Position)
					end
				end
			else
				-- Idle behavior
				humanoid.WalkSpeed = CHASE_SPEED
				humanoid:MoveTo(rootPart.Position)
			end
		end
	end
end

return MonsterScript