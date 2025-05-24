local success, result = pcall(function(): ()
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	game.StarterGui:SetCore("ResetButtonCallback", false)
end)

if success then
	print("Ui disabled")
else
	warn("Failed to disable ui: ", result)
end
