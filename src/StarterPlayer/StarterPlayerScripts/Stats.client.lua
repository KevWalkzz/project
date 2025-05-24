--strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local eventsFolder = ReplicatedStorage:WaitForChild("Events") :: Folder

local Strength = eventsFolder:WaitForChild("TrainStrength") :: RemoteEvent
local Endurance = eventsFolder:WaitForChild("TrainEndurance") :: RemoteEvent
local Speed = eventsFolder:WaitForChild("TrainSpeed") :: RemoteEvent
local Health = eventsFolder:WaitForChild("Health") :: RemoteEvent
local Intelligence = eventsFolder:WaitForChild("Intelligence") :: RemoteEvent
local Qi = eventsFolder:WaitForChild("QiEvent") :: RemoteEvent
local Age = eventsFolder:WaitForChild("Age") :: RemoteEvent
local Time = eventsFolder:WaitForChild("Time") :: RemoteEvent

local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer or error("LocalPlayer is nil!")
local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui
local main = playerGui:WaitForChild("Main") :: ScreenGui
local statsFrame = main:WaitForChild("Background"):WaitForChild("02-StatsFrame") :: Frame
local healthText = statsFrame:FindFirstChild("Health") :: TextLabel
local strengthText = statsFrame:FindFirstChild("Strength") :: TextLabel
local enduranceText = statsFrame:FindFirstChild("Endurance") :: TextLabel
local speedText = statsFrame:FindFirstChild("Speed") :: TextLabel
local intelText = statsFrame:FindFirstChild("Intelligence") :: TextLabel
local ageText = statsFrame:FindFirstChild("Age") :: TextLabel
local timeText = main:WaitForChild("Stamina"):WaitForChild("Time") :: TextLabel
local qiText = playerGui
	:WaitForChild("Main")
	:WaitForChild("Background")
	:WaitForChild("04-CultivationFrame")
	:FindFirstChild("QiText") :: TextLabel

local function updateTextLabel(label: TextLabel?, text: string): ()
	if label then
		label.Text = text
	else
		warn("Missing TextLabel for: " .. text)
	end
end

-- Strength Event
Strength.OnClientEvent:Connect(function(strength: number, trainName: string?): ()
	updateTextLabel(strengthText, "Strength: " .. tostring(strength))
	print(if trainName then "Strength Train: " .. trainName else "Updating Strength Value: " .. tostring(strength))
end)

-- Endurance Event
Endurance.OnClientEvent:Connect(function(endurance: number, trainName: string?): ()
	updateTextLabel(enduranceText, "Endurance: " .. tostring(endurance))
	print(if trainName then "Endurance Train: " .. trainName else "Updating Endurance Value: " .. tostring(endurance))
end)

-- Speed Event
Speed.OnClientEvent:Connect(function(speed: number, trainName: string?): ()
	updateTextLabel(speedText, "Speed: " .. tostring(speed))
	print(if trainName then "Speed Train: " .. trainName else "Updating Speed Value: " .. tostring(speed))
end)

-- Health Event
Health.OnClientEvent:Connect(function(health: number): ()
	updateTextLabel(healthText, "Health: " .. tostring(health))
	print("Updating Health Value: " .. tostring(health))
end)

-- Intelligence Event
Intelligence.OnClientEvent:Connect(function(intelligence: number, studyName: string?): ()
	updateTextLabel(intelText, "Intelligence: " .. tostring(intelligence))
	print(if studyName then "Study: " .. studyName else "Updating Intelligence Value: " .. tostring(intelligence))
end)

Qi.OnClientEvent:Connect(function(QiValue: number): ()
	updateTextLabel(qiText, "Qi: " .. tostring(QiValue))
	print("Updating Qi Value: " .. tostring(QiValue))
end)

Age.OnClientEvent:Connect(function(ageVal: number, _lifespanVal: number): ()
	updateTextLabel(ageText, "Age: " .. tostring(ageVal))
	Age:FireServer()
	print("Updating Age Value: " .. tostring(ageVal))
end)

Time.OnClientEvent:Connect(function(currentTime, timeValue): ()
	local TimeText =
		`Time: Y{currentTime.Year} M{currentTime.Month} D{currentTime.Day} {currentTime.Hour or timeValue.Hour}H`
	print(TimeText)
	updateTextLabel(timeText, tostring(TimeText))
end)
