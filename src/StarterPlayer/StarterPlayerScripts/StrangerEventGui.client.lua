local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local beaten = eventsFolder:WaitForChild("Beaten")
local tween = require(ReplicatedStorage.TweenHandler)
local typeWrite = require(ReplicatedStorage.Typewriter)

local player = Players.LocalPlayer :: Player
local playerGui = player.PlayerGui :: PlayerGui
local eventsGui = playerGui:WaitForChild("EventsGui") :: ScreenGui
local BG = eventsGui.Background :: Frame
local message = BG.Messages :: TextButton
local textHolder = BG.DialogFrame :: Frame
local text = textHolder.Text :: TextButton
local charName = BG.CharName :: TextLabel
local nameStroke = charName.UIStroke :: UIStroke
local backImage = BG.Forest :: ImageLabel
local strangeMan = BG.StrangeMan :: ImageLabel
local choicesFrame = BG.ChoicesFrame :: Frame
local cloneTemplate = BG.choiceTemplate :: TextButton

eventsGui.Enabled = false
textHolder.Transparency = 1
text.TextTransparency = 1
charName.TextTransparency = 1
nameStroke.Transparency = 1
backImage.ImageTransparency = 1
strangeMan.ImageTransparency = 1
cloneTemplate.Transparency = 1

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
		typeWrite.type(object, Text, speed, skipFlag)
	end)

	object.MouseButton1Click:Connect(function(): ()
		skipFlag.value = true
	end)

	task.wait(#Text * speed)

	waitForClick(object, timeout)
end

beaten.OnClientEvent:Connect(function(): ()
	eventsGui.Enabled = true
	backImage.ImageTransparency = 0
	showTextAndWait(message, "As you decide to explore some new lands you find yourself lost.", 0.05, 5)
	showTextAndWait(message, "Deep inside the woods.", 0.05, 5)
	showTextAndWait(message, "Suddenly, footsteps crunching the grass could be heard approaching.", 0.05, 5)
	showTextAndWait(message, "It seems to come right from the path you came.", 0.05, 5)
	showTextAndWait(message, "You find yourself increasingly anxious, expecting a wild creature to come out.", 0.05, 5)
	showTextAndWait(
		message,
		"Weak, slow, fragile. That's how you feel. Then suddenly you hear a stick cracking.",
		0.05,
		5
	)
	showTextAndWait(message, "But...", 0.05, 5)
	showTextAndWait(message, "An strange man wearing a circular yet exotic hat comes out of the woods.", 0.05, 5)
	showTextAndWait(message, '"Who could it be?" You ask to yourself.', 0.05, 5)
	tween.Animate(message, { Transparency = 1 }, 0.5)
	tween.Animate(textHolder, { Transparency = 0.7 }, 1)
	tween.Animate(text, { TextTransparency = 0 }, 1)
	showTextAndWait(text, "Oh...", 0.05, 3)
	tween.Animate(strangeMan, { ImageTransparency = 0 }, 1)
	tween.Animate(charName, { TextTransparency = 0 }, 1)
	tween.Animate(nameStroke, { Transparency = 0 }, 1)
	showTextAndWait(text, "You look a bit scared, little man.", 0.05, 5)
	showTextAndWait(text, "No wonder why. You look skinny as a stick.", 0.05, 5)
	showTextAndWait(text, "Sorry, no mean to offend you, really.", 0.05, 5)
	showTextAndWait(text, "But... you do look strange. It is not your face, but what is inside you.", 0.05, 5)
	showTextAndWait(text, "What? You don't believe in me?", 0.05, 5)
	charName.Text = "Your Thoughts"
	showTextAndWait(text, "I don't even said anything...", 0.05, 5)
	charName.Text = "Strange Man"
	showTextAndWait(text, "You don't have to.", 0.05, 5)
	charName.Text = "Your Thoughts"
	showTextAndWait(text, "WHAT. THE. HELL?", 0.05, 5)
	charName.Text = "Strange Man"
	showTextAndWait(text, "Stop thinking start listening to the older ones.", 0.05, 5)
	charName.Text = "You"
	showTextAndWait(text, "Wha-", 0.05, 2)
	showTextAndWait(text, "Uh...", 0.05, 2)
	showTextAndWait(text, "Ehrm-...", 0.05, 2)
	showTextAndWait(text, "👍", 0.05, 2)
	charName.Text = "Strange Man"
	showTextAndWait(text, "Good, good.", 0.05, 5)
	showTextAndWait(text, "As i was saying...", 0.05, 5)
	showTextAndWait(
		text,
		'You do look different from the inside, that means you can do some "special" things.',
		0.05,
		5
	)
	showTextAndWait(
		text,
		"What does that mean? You can follow the path of <font color='rgb(255,0,0)'>Immortality</font>.",
		0.05,
		5
	)
	showTextAndWait(
		text,
		"And with <font color='rgb(255,0,0)'>me</font> only with <font color='rgb(255,0,0)'>me</font>, you can achieve this.",
		0.05,
		5
	)
	showTextAndWait(text, "What do <font color='rgb(0,255,0)'>You</font> say?", 0.05, 5)

	local accept = cloneTemplate:Clone()
	accept.Parent = choicesFrame
	accept.Name = "Accept"
	accept.Text = "Accept"
	tween.Animate(accept, { TextTransparency = 0 }, 1)
	accept.TextColor3 = Color3.fromRGB(0, 255, 0)

	local refuse = cloneTemplate:Clone()
	refuse.Parent = choicesFrame
	refuse.Name = "Refuse"
	refuse.Text = "Refuse"
	tween.Animate(refuse, { TextTransparency = 0 }, 1)
	refuse.TextColor3 = Color3.fromRGB(255, 0, 0)
end)
