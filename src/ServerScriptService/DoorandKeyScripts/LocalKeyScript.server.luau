local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = script.Parent 

print("[Intro] Script started. Waiting for UI elements...")

-- If the script freezes here, your BackgroundFrame is named wrong or in the wrong place!
local background = gui:WaitForChild("BackgroundFrame")
print("[Intro] Found BackgroundFrame!")

-- If the script freezes here, IntroText is not inside BackgroundFrame!
local textLabel = background:WaitForChild("IntroText")
print("[Intro] Found IntroText! Setup complete.")

local canSkip = false
local introFinished = false

task.wait(1)
canSkip = true
print("[Intro] Ready to skip! Press any button.")

local function endIntro()
	if introFinished then return end
	introFinished = true
	print("[Intro] Starting fade out...")

	local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	local frameTween = TweenService:Create(background, tweenInfo, {BackgroundTransparency = 1})
	local textTween = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})

	frameTween:Play()
	textTween:Play()

	frameTween.Completed:Wait()
	print("[Intro] Fade complete. Destroying UI.")
	gui:Destroy()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if not canSkip then 
		print("[Intro] Click ignored: canSkip is still false.")
		return 
	end

	print("[Intro] Input detected: " .. tostring(input.UserInputType))

	if input.UserInputType == Enum.UserInputType.MouseButton1 
		or input.UserInputType == Enum.UserInputType.Touch 
		or input.UserInputType == Enum.UserInputType.Keyboard 
		or input.UserInputType == Enum.UserInputType.Gamepad1 then

		endIntro()
	end
end)