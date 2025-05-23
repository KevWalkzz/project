-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer or error("LocalPlayer is nil!")
local PlayerGui = player:WaitForChild("PlayerGui") :: PlayerGui

local AnimationHandler = require(ReplicatedStorage:WaitForChild("TweenHandler"))

-- Vars
local Buttons = PlayerGui:WaitForChild("Buttons"):WaitForChild("Buttons") :: Frame
local easingStyle: Enum.EasingStyle = Enum.EasingStyle.Quad
local easingDirection: Enum.EasingDirection = Enum.EasingDirection.InOut

local UnlockTraining = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UnlockTraining")
local UnlockCultivation = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UnlockCultivation")
local UnlockAffinities = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UnlockAffinities")

local Background = PlayerGui:WaitForChild("Main"):WaitForChild("Background") :: Frame
local PageLayout = Background:WaitForChild("UIPageLayout") :: UIPageLayout
local HomePage = Background:WaitForChild("01-HomeFrame") :: Frame
local StatPage = Background:WaitForChild("02-StatsFrame") :: Frame
local TrainPage = Background:WaitForChild("03-TrainFrame") :: Frame
local CultivatePage = Background:WaitForChild("04-CultivationFrame") :: Frame

local currentPage: string = "Home"

PageLayout.ScrollWheelInputEnabled = false
Buttons.Visible = true
TrainPage.Visible = false
CultivatePage.Visible = false

-- Functions
for _i, v in pairs(Buttons:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseEnter:Connect(function()
			AnimationHandler.Animate(v, { BackgroundTransparency = 0 }, 0.25, easingStyle, easingDirection)
			AnimationHandler.Animate(
				v,
				{ BackgroundColor3 = Color3.fromRGB(20, 20, 20) },
				0.25,
				easingStyle,
				easingDirection
			)
		end)

		v.MouseLeave:Connect(function()
			AnimationHandler.Animate(v, { BackgroundTransparency = 0.2 }, 0.25, easingStyle, easingDirection)
			AnimationHandler.Animate(
				v,
				{ BackgroundColor3 = Color3.fromRGB(30, 30, 30) },
				0.25,
				easingStyle,
				easingDirection
			)
		end)

		v.MouseButton1Click:Connect(function()
			if currentPage == v.Name then
				warn("You're on the page, idiot! " .. "(" .. currentPage .. ")")
				return
			end

			if v.Name == "01-Home" then
				currentPage = v.Name
				PageLayout:JumpTo(HomePage)
			elseif v.Name == "02-Stats" then
				currentPage = v.Name
				PageLayout:JumpTo(StatPage)
			elseif v.Name == "03-Train" then
				currentPage = v.Name
				PageLayout:JumpTo(TrainPage)
			elseif v.Name == "04-Cultivate" then
				currentPage = v.Name
				PageLayout:JumpTo(CultivatePage)
			end
		end)
	end
end

-- Events

UnlockCultivation.OnClientEvent:Once(function()
	local cultivateButton = Buttons:FindFirstChild("04-Cultivate")
	if cultivateButton and cultivateButton:IsA("GuiObject") then
		cultivateButton.Visible = true
	end
	CultivatePage.Visible = true
end)

UnlockAffinities.OnClientEvent:Once(function()
	local discAffButton = HomePage:WaitForChild("ActionList"):WaitForChild("DiscAff")
	if discAffButton and discAffButton:IsA("GuiObject") then
		discAffButton.Visible = true
	end
end)

UnlockTraining.OnClientEvent:Once(function()
	local trainButton = Buttons:FindFirstChild("03-Train")
	if trainButton and trainButton:IsA("GuiObject") then
		trainButton.Visible = true
	end
	TrainPage.Visible = true
end)
