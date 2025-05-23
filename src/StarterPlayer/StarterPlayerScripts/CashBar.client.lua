--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer or error("LocalPlayer is nil!")
local PlayerGui = player:WaitForChild("PlayerGui") :: PlayerGui

local goldEvent = Events:WaitForChild("GoldText") :: RemoteEvent
local goldText = PlayerGui:WaitForChild("Main"):WaitForChild("Currency"):WaitForChild("GoldText") :: TextLabel

goldEvent.OnClientEvent:Connect(function(currentGold: number, action: string?): ()
	goldText.Text = "Gold: " .. tostring(currentGold)
	print("Gained " .. tostring(currentGold) .. " gold by: " .. tostring(action))
end)
