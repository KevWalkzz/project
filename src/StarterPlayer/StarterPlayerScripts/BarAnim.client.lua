local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer or error("LocalPlayer is nil!")
local PlayerGui = player:WaitForChild("PlayerGui") :: PlayerGui

local AnimationHandler = require(game.ReplicatedStorage:WaitForChild("TweenHandler")) :: ModuleScript
local stamEvent = RS:WaitForChild("Events"):WaitForChild("Stamina")
local bar = PlayerGui:WaitForChild("Main").Stamina.Stamina.Bar :: CanvasGroup
local stamText: TextLabel = bar.Parent.TextLabel
	
stamEvent.OnClientEvent:Connect(function(currentStamina)
	AnimationHandler.Animate(bar, {Size = UDim2.new(currentStamina / 10, 0, .8, 0)}, 0.3)
	stamText.Text = "Energy: " .. currentStamina .. "/10"
end)
