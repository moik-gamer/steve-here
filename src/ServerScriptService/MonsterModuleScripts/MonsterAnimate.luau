local MonsterAnimate = {}

function MonsterAnimate.StartLogic(Monster)
	-- 🛠️ DIAGNOSTIC PRINT 1: Proves the script successfully started running on this monster
	print("MonsterAnimate has successfully started logic for: " .. Monster.Name)

	local Humanoid = Monster:WaitForChild("Humanoid")

	-- FORCE-AWAKE SYSTEM STATES
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	Humanoid:ChangeState(Enum.HumanoidStateType.Running)

	-- Look for the animations inside the Monster model in the Workspace
	local IdleAnimation = Monster:WaitForChild("IdleAnim")
	local WalkAnimation = Monster:WaitForChild("WalkAnim")

	-- Track variables
	local idleTrack = nil
	local walkTrack = nil

	-- Wait for Animator to prevent deprecated Humanoid:LoadAnimation() warnings
	local Animator = Humanoid:WaitForChild("Animator")

	-- Load the animations onto the Animator track
	idleTrack = Animator:LoadAnimation(IdleAnimation)
	walkTrack = Animator:LoadAnimation(WalkAnimation)

	-- Set Priorities (So walking overlays smoothly onto idling)
	walkTrack.Priority = Enum.AnimationPriority.Action
	idleTrack.Priority = Enum.AnimationPriority.Idle

	-- Start by playing the idle animation
	idleTrack:Play()

	-- Detect when the monster moves
	Humanoid.Running:Connect(function(speed)
		-- 🛠️ DIAGNOSTIC PRINT 2: Shows us exactly what speed the Humanoid thinks it is moving at
		print("ANIMATION STATE SIGNAL: Monster speed variable is currently: " .. tostring(speed))

		if speed > 0.5 then
			-- Monster is moving
			if not walkTrack.IsPlaying then
				walkTrack:Play(0.2) -- 0.2 second fade-in transition
			end
			if idleTrack.IsPlaying then
				idleTrack:Stop(0.2)
			end

			-- Dynamic animation speed based on how fast the monster actually walks
			walkTrack:AdjustSpeed(Humanoid.WalkSpeed / 16) 
		else
			-- Monster stopped
			if walkTrack.IsPlaying then
				walkTrack:Stop(0.2)
			end
			if not idleTrack.IsPlaying then
				idleTrack:Play(0.2)
			end
		end
	end)

	-- Handle sudden death
	Humanoid.Died:Connect(function()
		idleTrack:Stop()
		walkTrack:Stop()
	end)

end

return MonsterAnimate