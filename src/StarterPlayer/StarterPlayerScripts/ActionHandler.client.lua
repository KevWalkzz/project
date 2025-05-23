local buttonToRemote = {
	SleepButton = "Sleep",
	WorkButton = "Work",
	ExploreButton = "Explore",
	PunchDummies = "TrainStrength",
	StepOnEmbers = "TrainEndurance",
	RunAround = "TrainSpeed",
	ReadBooks = "Intelligence",
	DiscAff = "DiscoverAffinity",
}

local texts = {
	WorkButton = "Work",
	RunAround = "Run Around",
	ReadBooks = "Read Books",
}

local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer or error("LocalPlayer is nil!")
local PlayerGui = player:WaitForChild("PlayerGui") :: PlayerGui

local BG = PlayerGui:WaitForChild("Main").Background

local homeFrame = BG["01-HomeFrame"]
local trainFrame = BG["03-TrainFrame"]

local homeHoverGui = BG.Parent.Parent:WaitForChild("Hover")
local homeHoverFrame = homeHoverGui:WaitForChild("HoverFrame")
local mouse = game.Players.LocalPlayer:GetMouse()

local activeButton = nil
local progressTask = nil

local function getAllButtons()
	local actionLists = {
		homeFrame.ActionList,
		homeFrame.LoopActionList,
		trainFrame.ActionList,
		trainFrame.LoopActionList,
	}
	local buttons = {}

	for _, list in pairs(actionLists) do
		for _, child in pairs(list:GetChildren()) do
			if child:IsA("TextButton") then
				table.insert(buttons, child)
			end
		end
	end

	return buttons
end

-- Function to start progress
local function startProgress(button, remoteName, text)
	-- Cancel the previous progress if any
	if progressTask then
		task.cancel(progressTask)
		progressTask = nil
	end

	-- Reset the previous button's appearance
	if activeButton then
		activeButton.BackgroundColor3 = Color3.fromRGB(94, 94, 94)
		activeButton.Text = texts[activeButton.Name] or activeButton.Name
	end

	-- Set the new active button
	activeButton = button
	activeButton.BackgroundColor3 = Color3.fromRGB(157, 0, 0)

	-- Start the progress task
	progressTask = task.spawn(function()
		while activeButton == button do
			for i = 1, 100 do
				-- Check if the button was deactivated or replaced
				if activeButton ~= button then
					button.BackgroundColor3 = Color3.fromRGB(94, 94, 94)
					button.Text = text -- Reset to original text
					print("Stopped " .. text .. " progress!")
					return
				end

				-- Update the button text
				button.Text = text .. " (" .. i .. "%)"
				task.wait(0.1)

				-- If progress reaches 100%, fire the event and reset the progress
				if i == 100 then
					game.ReplicatedStorage.Events[remoteName]:FireServer(button.Action.Value)
					print("Completed " .. text .. " progress!")
				end
			end
		end

		-- Reset the button when the loop ends
		button.BackgroundColor3 = Color3.fromRGB(94, 94, 94)
		button.Text = text
		activeButton = nil
		print("Stopped " .. text .. " progress!")
	end)
end

for _i, v in pairs(getAllButtons()) do
	if v:IsA("TextButton") then
		-- Show a frame with a description when hovered
		v.MouseEnter:Connect(function()
			homeHoverFrame.Position = UDim2.new(0, mouse.X + 30, 0, mouse.Y)
			homeHoverFrame.ScrollingFrame.Action.Text = v.Action.Value
			homeHoverFrame.ScrollingFrame.Description.Text = v.Description.Value
			homeHoverFrame.ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
			homeHoverFrame.Visible = true
		end)

		v.MouseMoved:Connect(function()
			homeHoverFrame.Position = UDim2.new(0, mouse.X + 30, 0, mouse.Y)
			homeHoverFrame.Visible = true
		end)

		v.MouseLeave:Connect(function()
			homeHoverFrame.Position = UDim2.new(0, mouse.X + 30, 0, mouse.Y)
			homeHoverFrame.Visible = false
		end)

		v.MouseButton1Click:Connect(function()
			local remoteName = buttonToRemote[v.Name]
			local text = texts[v.Name] or v.Name

			if remoteName and v.Parent.Name ~= "LoopActionList" then
				if remoteName == "DiscoverAffinity" then
					v.Visible = false
				end -- Make Only Discover Affinity Button invisible when clicked
				game.ReplicatedStorage.Events[remoteName]:FireServer(v.Action.Value)
			elseif remoteName and v.Parent.Name == "LoopActionList" then
				-- Start or cancel progress
				if activeButton == v then
					-- Cancel progress if the same button is clicked again
					if progressTask then
						task.cancel(progressTask)
						progressTask = nil
					end
					activeButton = nil
					v.BackgroundColor3 = Color3.fromRGB(94, 94, 94)
					v.Text = text
					print("Stopped " .. text .. " progress!")
				else
					-- Start progress for the new button
					startProgress(v, remoteName, text)
				end
			end
		end)
	end
end
