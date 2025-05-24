local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DeathEvent = ReplicatedStorage.Events.Death
local TweenHandler = require(game.ReplicatedStorage.TweenHandler)
local Typewriter = require(game.ReplicatedStorage.Typewriter)

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local deathGui = playerGui:WaitForChild("DeathGui")
local image = deathGui.BG:WaitForChild("ImageLabel")
local text = deathGui.BG:WaitForChild("TextLabel")
local yes = deathGui.BG:WaitForChild("Yes")
local outerLine = yes.OuterStroke
local innerLine = yes.InnerStroke
local no = deathGui.BG:WaitForChild("No")
local outerLine2 = no.OuterStroke
local innerLine2 = no.InnerStroke

deathGui.Enabled = false
deathGui.BG.Transparency = 1
image.ImageTransparency = 1
text.TextTransparency = 1
yes.TextTransparency = 1
yes.Transparency = 1
innerLine.Transparency = 1
outerLine.Transparency = 1
no.TextTransparency = 1
no.Transparency = 1
innerLine2.Transparency = 1
outerLine2.Transparency = 1

local skipFlag = { value = false }

local function waitForClick(button: TextButton, timeout: number): ()
	local clicked = false
	local connection = button.MouseButton1Click:Connect(function(): ()
		clicked = true
	end)

	local startTime = os.clock()
	while not clicked and os.clock() - startTime < timeout do
		task.wait()
	end

	connection:Disconnect()
end

local function showTextAndWait(object: any, Text: string, speed: number, timeout: number)
	skipFlag.value = false

	local _typingThread = task.spawn(function(): ()
		Typewriter.type(object, Text, speed, skipFlag)
	end)

	object.MouseButton1Click:Connect(function(): ()
		skipFlag.value = true
	end)

	task.wait(#Text * speed)

	waitForClick(object, timeout)
end

DeathEvent.OnClientEvent:Connect(function(): ()
	deathGui.Enabled = true
	deathGui.BG.Transparency = 0

	TweenHandler.Animate(text, { TextTransparency = 0 }, 1)
	showTextAndWait(text, "Hey...", 0.05, 2)
	TweenHandler.Animate(image, { ImageTransparency = 0 }, 1)
	showTextAndWait(text, "It seems that your life has come to an end.", 0.05, 4)
	showTextAndWait(text, "What will you do?", 0.05, 2)
	task.wait(2)
	TweenHandler.Animate(yes, { TextTransparency = 0, Transparency = 0 }, 1)
	TweenHandler.Animate(innerLine, { Transparency = 0 }, 1)
	TweenHandler.Animate(outerLine, { Transparency = 0 }, 1)
	task.wait(0.7)
	TweenHandler.Animate(no, { TextTransparency = 0, Transparency = 0 }, 1)
	TweenHandler.Animate(innerLine2, { Transparency = 0 }, 1)
	TweenHandler.Animate(outerLine2, { Transparency = 0 }, 1)
end)
