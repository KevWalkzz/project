--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer or error("LocalPlayer is nil!")
local PlayerGui = player:WaitForChild("PlayerGui") :: PlayerGui

local goldEvent = ReplicatedStorage.Events:WaitForChild("GoldText") :: RemoteEvent
local goldText = PlayerGui:WaitForChild("Main"):WaitForChild("Currency"):WaitForChild("GoldText") :: TextLabel

goldEvent.OnClientEvent:Connect(function(currentGold: number, action)
	goldText.Text = "Gold: " .. tostring(currentGold)
	print("Gained " .. tostring(currentGold) .. " gold by: " .. action)
end)
