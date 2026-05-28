-- Get the part this script is inside
local part = script.Parent

game.Workspace.Baseplate.Material = "Brick"

-- Function to run when something touches the part
local function onTouch(hit)
	-- Check if the touching object belongs to a player
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)

	if player then
		print(player.Name .. " touched the part!")
	end
end

-- Connect the function to the Touched event
part.Touched:Connect(onTouch)

--that one bro who is sus and among us 
--that one tung when he sahurs


local part = script.Parent
local speed = 20 -- studs per second
local chaseDistance = 50 -- start chasing if player is within this range

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

RunService.Heartbeat:Connect(function(deltaTime)
	local player = Players.LocalPlayer or Players:GetPlayers()[1]
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local targetPos = player.Character.HumanoidRootPart.Position
		local distance = (targetPos - part.Position).Magnitude

		if distance <= chaseDistance then
			local direction = (targetPos - part.Position).Unit
			part.Position = part.Position + direction * speed * deltaTime
		end
	end
end)
