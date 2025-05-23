local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local beaten = eventsFolder:WaitForChild("Beaten")
local tween = require(ReplicatedStorage.TweenHandler)
local typeWrite = require(ReplicatedStorage.Typewriter)

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local eventsGui = playerGui:WaitForChild("EventsGui")
local BG = eventsGui.Background
local message = BG.Messages
local textHolder = BG.TextHolder
local text = textHolder.Text
local charName = BG.CharName
local nameStroke = charName.UIStroke
local backImage = BG.Forest
local strangeMan = BG.StrangeMan
local accept = textHolder.Accept
local refuse = textHolder.Refuse

eventsGui.Enabled = false
textHolder.Transparency = 1
text.TextTransparency = 1
charName.TextTransparency = 1
nameStroke.Transparency = 1
backImage.ImageTransparency = 1
strangeMan.ImageTransparency = 1
accept.Transparency = 1
refuse.Transparency = 1

-- Do a "Click to Continue" thing here

beaten.OnClientEvent:Connect(function()
	eventsGui.Enabled = true
	backImage.ImageTransparency = 0
	typeWrite.type(message, "As you decide to explore some new lands you find yourself lost.", 0.05)
	task.wait(3)
	typeWrite.type(message, "Deep inside the woods.", 0.05)
	task.wait(3)
	typeWrite.type(message, "Suddenly, footsteps crunching the grass could be heard approaching.", 0.05)
	task.wait(3)
	typeWrite.type(message, "It seems to come right from the path you came.", 0.05)
	task.wait(3)
	typeWrite.type(message, "You find yourself increasingly anxious, expecting a wild creature to come out.", 0.05)
	task.wait(4)
	typeWrite.type(message, "Weak, slow, fragile. That's how you feel. Then suddenly you hear a stick cracking.", 0.05)
	task.wait(4)
	typeWrite.type(message, "But...", 0.1)
	task.wait(3)
	typeWrite.type(message, "An strange man wearing a circular yet exotic hat comes out of the woods.", 0.05)
	task.wait(3)
	typeWrite.type(message, '"Who could it be?" You ask to yourself.', 0.05)
	task.wait(3)
	tween.Animate(textHolder, { Transparency = 0.7 }, 1)
	tween.Animate(message, { TextTransparency = 1 }, 0.5)
	tween.Animate(text, { TextTransparency = 0 }, 0.5)
	typeWrite.type(text, "Oh...", 0.1)
	task.wait(4)
	tween.Animate(strangeMan, { ImageTransparency = 0 }, 1)
	tween.Animate(charName, { TextTransparency = 0 }, 1)
	tween.Animate(nameStroke, { Transparency = 0 }, 1)
	typeWrite.type(text, "You look a bit scared, little man.", 0.05)
	task.wait(4)
	typeWrite.type(text, "No wonder why. You look skinny as a stick.", 0.05)
	task.wait(3)
	typeWrite.type(text, "Although you look some kind of... different than i expected.", 0.05)
	task.wait(4)
	typeWrite.type(text, "I can help you, but only if you agree. Don't rush that decision.", 0.05)
	task.wait(2)
	tween.Animate(accept, { Transparency = 0 }, 1)
	tween.Animate(refuse, { Transparency = 0 }, 1)
end)
