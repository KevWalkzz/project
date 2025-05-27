-- services
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")

-- requires
local PlayerDataHandler = require(SSS:WaitForChild("PlayerDataHandler"))
local Rarities = require(game.ServerStorage:WaitForChild("Rarities"))
local RarityService = require(game.ServerStorage:WaitForChild("RarityService"))
local GetData = require(SSS.Server:WaitForChild("GetData"))
local DataUpdater = require(SSS.Server:WaitForChild("DataUpdater"))

-- vars
local EventsFolder = game.ReplicatedStorage:WaitForChild("Events")
local Work = EventsFolder:WaitForChild("Work")
local Sleep = EventsFolder:WaitForChild("Sleep")
local Stamina = EventsFolder:WaitForChild("Stamina")
local Explore = EventsFolder:WaitForChild("Explore")
local messages = EventsFolder:WaitForChild("Messages")
local trainStr = EventsFolder:WaitForChild("TrainStrength")
local trainEnd = EventsFolder:WaitForChild("TrainEndurance")
local trainSpd = EventsFolder:WaitForChild("TrainSpeed")
local goldText = EventsFolder:WaitForChild("GoldText")
local discoverAff = EventsFolder:WaitForChild("DiscoverAffinity")
local affResults = EventsFolder:WaitForChild("ShowAffinityResults")
local Health = EventsFolder:WaitForChild("Health")
local Intelligence = EventsFolder:WaitForChild("Intelligence")
local Time = EventsFolder:WaitForChild("Time")
local Age = EventsFolder:WaitForChild("Age")
local Death = EventsFolder:WaitForChild("Death")

-- == FUNCTIONS == --

-- == EVENTS == --

-- START PLAYER STATS --
Players.PlayerAdded:Connect(function(player: Player)
	local currentStamina, currentGold, currentStrength, currentEndurance, currentSpeed, currentHp, currentIntel, currentTime, currentAge, currentLifespan =
		GetData.Data(
			player,
			"Stamina",
			"Gold",
			"Strength",
			"Endurance",
			"Speed",
			"Health",
			"Intelligence",
			"Time",
			"Age",
			"Lifespan"
		)
	Stamina:FireClient(player, currentStamina)
	goldText:FireClient(player, currentGold)
	trainStr:FireClient(player, currentStrength)
	trainEnd:FireClient(player, currentEndurance)
	trainSpd:FireClient(player, currentSpeed)
	Health:FireClient(player, currentHp)
	Intelligence:FireClient(player, currentIntel)
	DataUpdater.checkKnowledge(player)
	Time:FireClient(player, currentTime)
	Age:FireClient(player, currentAge, currentLifespan)
end)

-- SLEEP REMOTE --
Sleep.OnServerEvent:Connect(function(player): ()
	local stamina, maxStamina = GetData.Data(player, "Stamina", "MaxStamina")
	if stamina >= maxStamina then
		messages:FireClient(player, "You are fully rested already.")
		return
	end

	DataUpdater.updateTime(player, 1, Time, Age)
	DataUpdater.updateSleep(player, 1, Stamina)
end)

-- WORK REMOTE --
Work.OnServerEvent:Connect(function(player): ()
	if player then
		local currentStamina = GetData.Data(player, "Stamina")
		if currentStamina < 1 then
			messages:FireClient(player, "You are too tired to work.")
			return
		end

		DataUpdater.updateTime(player, 1, Time, Age)
		DataUpdater.updateGold(player, 1, 1, goldText, Stamina, "Work")
		print(PlayerDataHandler:Get(player, "Gold"))
	end
end)

-- EXPLORE REMOTE --
Explore.OnServerEvent:Connect(function(player): ()
	if player then
		local currentStamina = GetData.Data(player, "Stamina")
		if currentStamina < 2 then
			messages:FireClient(player, "You are too tired to explore.")
			return
		end

		DataUpdater.updateTime(player, 2, Time, Age)

		PlayerDataHandler:Update(player, "Stamina", function(actualStamina): any
			local newStamina = actualStamina - 2
			Stamina:FireClient(player, newStamina)
			return newStamina
		end)

		PlayerDataHandler:Update(player, "EventsFired", function(event): ()
			event.Exploring += 9
			if event.Exploring >= 10 then
				event.Beaten = true
				DataUpdater.checkKnowledge(player)
			end

			print("Exploring count: " .. event.Exploring)
			return event
		end)
	end
end)

-- STRENGTH REMOTE --
trainStr.OnServerEvent:Connect(function(player, trainName): ()
	if player then
		local currentStamina = GetData.Data(player, "Stamina")

		if currentStamina < 1 then
			messages:FireClient(player, "You are too much tired to punch the dummies.")
			return
		end

		DataUpdater.updateTime(player, 1, Time, Age)
		DataUpdater.updateStrength(player, 1, 1, Stamina, trainStr, trainName)
	end
end)

-- ENDURANCE REMOTE --
trainEnd.OnServerEvent:Connect(function(player, trainName): ()
	local currentStamina = GetData.Data(player, "Stamina", "Endurance", "Health")

	if currentStamina < 2 then
		messages:FireClient(player, "You don't have enough energy to walk on embers.")
		return
	end

	DataUpdater.updateTime(player, 1, Time, Age)
	DataUpdater.updateEndurance(player, 2, 1, 1, Stamina, trainEnd, Health, trainName)
end)

-- SPEED REMOTE --
trainSpd.OnServerEvent:Connect(function(player, trainName): ()
	local currentStamina, _currentSpeed = GetData.Data(player, "Stamina", "Speed")

	if currentStamina < 1 then
		messages:FireClient(player, "You don't have energy to run.")
		return
	end

	DataUpdater.updateTime(player, 1, Time, Age)
	DataUpdater.updateSpeed(player, 1, Stamina, trainSpd, trainName)
end)

-- DISCOVER AFFINITIES REMOTE --
discoverAff.OnServerEvent:Connect(function(player): ()
	local luck, minAff, maxAff = GetData.Data(player, "Luck", "MinAffinities", "MaxAffinities")
	local affs = math.random(minAff, maxAff)
	local chosenAffinities = {}
	local affinityIndexes = {}

	for _i = minAff, affs do
		local index = RarityService.chooseIndex(Rarities, luck, chosenAffinities)

		if index then
			-- Update the player's affinities
			PlayerDataHandler:Update(player, "Affinities", function(currentAffs): { number }
				local newAffs = currentAffs
				-- Increment the count for the selected affinity
				newAffs[index] = newAffs[index] and newAffs[index] or 1
				print(newAffs)
				return newAffs
			end)

			-- Mark this affinity as chosen
			chosenAffinities[index] = true
			table.insert(affinityIndexes, index)

			-- If affinity already exists, skip
			if index == table.find(affinityIndexes, index) then
				continue
			end

			print("Chose rarity: " .. index)
			affResults:FireClient(player, index)
			task.wait(1)
		else
			print("No available rarity to choose.")
			break
		end
	end
end)

-- STUDY REMOTE --
Intelligence.OnServerEvent:Connect(function(player, studyName): ()
	local stamina = GetData.Data(player, "Stamina")

	if stamina < 1 then
		messages:FireClient(player, "You're not interested in studying right now.")
		return
	end

	DataUpdater.updateTime(player, 1, Time, Age)
	DataUpdater.updateIntel(player, 1, 90, Intelligence, Stamina, studyName)
	DataUpdater.checkKnowledge(player)
end)

-- AGE REMOTE --
Age.OnServerEvent:Connect(function(player): ()
	local age, lifespan = GetData.Data(player, "Age", "Lifespan")
	if (lifespan - age) == 1 then
		player.PlayerGui.Main.Stamina.LastYear.Visible = true
	end
	if age >= lifespan then
		Death:FireClient(player)
	end
end)
