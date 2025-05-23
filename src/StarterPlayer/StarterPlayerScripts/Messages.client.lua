--!strict

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer or error("LocalPlayer is nil!")

local Mes = player:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Messages") :: Frame
local messages = RS:WaitForChild("Message") :: TextLabel

local AnimationHandler = require(RS:WaitForChild("TweenHandler"))

local messagesEvent = RS:WaitForChild("Events"):WaitForChild("Messages") :: RemoteEvent
local showAffs = RS:WaitForChild("Events"):WaitForChild("ShowAffinityResults") :: RemoteEvent

local tweening = false

-- Define a Tip type
type Tip = { Message: string, Probability: number }
local tips: { Tip } = {
	{ Message = "Report any bugs!", Probability = 50 },
	{ Message = "The progress saves when you quit the game!", Probability = 50 },
	{ Message = "Explore the area to find hidden items, secret knowledge and more!", Probability = 50 },
	{ Message = "Check out the market, it may have something you need!", Probability = 50 },
	{ Message = "Remember to like the game if you're enjoying it!", Probability = 50 },
	{ Message = "You can scroll the hover frame to view more info, as well as this one!", Probability = 50 },
	{ Message = "Strength Increases your damage!", Probability = 50 },
	{ Message = "Endurance Increases your health, as well as your resistance!", Probability = 50 },
	{ Message = "Speed Increases the speed of attacks and loop actions!", Probability = 50 },
	{ Message = "You may not know everything, so make sure to explore a bit!", Probability = 50 },
}

local function sendMessage(message: string): ()
	messages.Text = message
	messages.TextTransparency = 1
	local messagesClone = messages:Clone() :: TextLabel
	messagesClone.Parent = Mes
	messagesClone.Text = message
	AnimationHandler.Animate(messagesClone, { TextTransparency = 0, BackgroundTransparency = 0 }, 1)
	task.wait(1)
end

local function chooseTip(lastTip: string?): string
	local totalProbability = 0

	for _, tip in ipairs(tips) do
		if tip.Message ~= lastTip then
			totalProbability += tip.Probability
		end
	end

	local randomChance = math.random(1, totalProbability)
	local cumulative = 0
	for _, tip in ipairs(tips) do
		if tip.Message ~= lastTip then
			cumulative += tip.Probability
			if randomChance <= cumulative then
				return tip.Message
			end
		end
	end

	return "Have a nice day!" -- Fallback message, shouldn't happen.
end

messagesEvent.OnClientEvent:Connect(function(message: string)
	if tweening then return end
	tweening = true
	print("Fired")
	sendMessage(message)
	tweening = false
end)

showAffs.OnClientEvent:Connect(function(affinities: string)
	sendMessage(affinities)
end)

local lastTip: string? = nil

local messageTips = coroutine.create(function()
	print("Executing Messages Tips!")
	while task.wait(120) do
		if tweening then
			repeat task.wait() until not tweening
		end
		tweening = true
		local randomTip = chooseTip(lastTip)
		lastTip = randomTip

		sendMessage(randomTip)

		tweening = false
	end
end)

coroutine.resume(messageTips)

local messagesDelete = coroutine.create(function()
	print("Executing Messages Delete!")
	while task.wait(60) do
		local messages = Mes:GetChildren()
		if #messages > 1 then
			for _, v in ipairs(messages) do
				if v:IsA("TextLabel") and v.Name == "Message" then
					v:Destroy()
				end
			end
		end
	end
end)

coroutine.resume(messagesDelete)
