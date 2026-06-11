----- variables -----

local interactive = script.Parent.Interactive
local lockInteractive = script.Parent.Lock.Interactive
local lock = script.Parent.Lock.Lock
local handle = script.Parent.Lock.LockHandle
local doorOpen = false
local doorLocked = false
local changingState = false

----- door -----

interactive.ClickDetector.MouseClick:Connect(function()
	if doorOpen and not changingState and not doorLocked then
		changingState = true
		for i = 1, 12 do
			script.Parent:SetPrimaryPartCFrame(script.Parent.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(7), 0))
			wait()
		end
		changingState = false
		doorOpen = false
		lockInteractive.ClickDetector.MaxActivationDistance = 12
	elseif not changingState and not doorLocked then
		doorOpen = true
		changingState = true
		lockInteractive.ClickDetector.MaxActivationDistance = 0
		for i = 1, 12 do
			script.Parent:SetPrimaryPartCFrame(script.Parent.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-7), 0))
			wait()
		end
		changingState = false
	end
end)

----- lock -----

lockInteractive.ClickDetector.MouseClick:Connect(function()
	if not doorOpen and not changingState then
		changingState = true
		if doorLocked then
			doorLocked = false
			interactive.ClickDetector.MaxActivationDistance = 12
			for i = 1, 5 do
				lock.CFrame = lock.CFrame * CFrame.new(0,0.02,0)
				handle.CFrame = handle.CFrame * CFrame.Angles(math.rad(-18),0,0)
				wait()
			end
		else
			doorLocked = true
			interactive.ClickDetector.MaxActivationDistance = 0
			for i = 1, 5 do
				lock.CFrame = lock.CFrame * CFrame.new(0,-0.02,0)
				handle.CFrame = handle.CFrame * CFrame.Angles(math.rad(18),0,0)
				wait()
			end
		end
		changingState = false
	end
end)