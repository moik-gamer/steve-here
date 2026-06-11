local MonsterAnimate = {}

function MonsterAnimate.StartLogic(Monster)
	local humanoid = Monster:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	-- Find your custom WalkAnim tracking asset inside the monster model
	local walkAnimObject = Monster:WaitForChild("WalkAnim")
	local walkTrack = animator:LoadAnimation(walkAnimObject)

	-- 🛠️ FIXED: Wrapped the loop in a task.spawn so it doesn't freeze your main controller script!
	task.spawn(function()
		while task.wait(0.1) do
			-- Safety check: Stop the loop if the monster gets destroyed/removed from the game
			if not Monster or not Monster.Parent then break end

			-- Check if the monster is actively moving faster than freezing speed
			if humanoid.WalkSpeed > 0 and humanoid.MoveDirection.Magnitude > 0 then
				if not walkTrack.IsPlaying then
					walkTrack:Play()
				end
			else
				-- If frozen or stopped, instantly freeze the animation track
				if walkTrack.IsPlaying then
					walkTrack:Stop()
				end
			end
		end
	end)
end

return MonsterAnimate