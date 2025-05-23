local DataUpdater = {}

local PlayerDataHandler = require(game.ServerScriptService:WaitForChild("PlayerDataHandler"))
local EventsFolder = game.ReplicatedStorage:WaitForChild("Events")
local UnlockCultivation = EventsFolder:WaitForChild("UnlockCultivation")
local UnlockAffinities = EventsFolder:WaitForChild("UnlockAffinities")
local UnlockTraining = EventsFolder:WaitForChild("UnlockTraining")
local Beaten = EventsFolder:WaitForChild("Beaten")

function DataUpdater.updateSleep(player, staminaAmount: number, staminaRemote: RemoteEvent)
	PlayerDataHandler:Update(player, "Stamina", function(currentStamina)
		local newStamina = currentStamina + staminaAmount
		staminaRemote:FireClient(player, newStamina)
		return newStamina
	end)
end

function DataUpdater.updateStamina(player, requiredStamina, staminaRemote)
	PlayerDataHandler:Update(player, "Stamina", function(currentStamina)
		if currentStamina >= requiredStamina then
			local newStamina = currentStamina - requiredStamina
			staminaRemote:FireClient(player, newStamina)
			return newStamina
		end
		return
	end)
end

function DataUpdater.updateGold(
	player: Player,
	goldAmount: number,
	requiredStamina: number,
	goldText: RemoteEvent,
	staminaRemote: RemoteEvent,
	actionName: string
)
	DataUpdater.updateStamina(player, requiredStamina, staminaRemote)

	PlayerDataHandler:Update(player, "Gold", function(currentGold)
		local newGold = currentGold + goldAmount
		goldText:FireClient(player, newGold, actionName)
		return newGold
	end)
end

function DataUpdater.updateStrength(
	player: Player,
	requiredStamina: number,
	strengthAmount: number,
	staminaRemote: RemoteEvent,
	trainStr: RemoteEvent,
	trainName: string
)
	DataUpdater.updateStamina(player, requiredStamina, staminaRemote)

	PlayerDataHandler:Update(player, "Strength", function(currentStrength)
		local newStrength = currentStrength + strengthAmount
		trainStr:FireClient(player, newStrength, trainName)
		return newStrength
	end)
end

function DataUpdater.updateEndurance(
	player,
	requiredStamina,
	enduranceAmount,
	healthAmount,
	staminaRemote,
	enduranceRemote,
	healthRemote,
	trainName
)
	DataUpdater.updateStamina(player, requiredStamina, staminaRemote)

	PlayerDataHandler:Update(player, "Endurance", function(currentEndurance)
		local newEndurance = currentEndurance + enduranceAmount
		enduranceRemote:FireClient(player, newEndurance, trainName)
		return newEndurance
	end)
	PlayerDataHandler:Update(player, "Health", function(currentHealth)
		local newHealth = currentHealth + healthAmount
		healthRemote:FireClient(player, newHealth)
		return newHealth
	end)
end

function DataUpdater.updateSpeed(player, requiredStamina, staminaRemote, speedRemote, trainName)
	DataUpdater.updateStamina(player, requiredStamina, staminaRemote)

	PlayerDataHandler:Update(player, "Speed", function(currentSpeed)
		local newSpeed = currentSpeed + 1
		speedRemote:FireClient(player, newSpeed, trainName)
		return newSpeed
	end)
end

function DataUpdater.updateIntel(player, requiredStamina, intelAmount, intelRemote, staminaRemote, studyName)
	DataUpdater.updateStamina(player, requiredStamina, staminaRemote)

	PlayerDataHandler:Update(player, "Intelligence", function(currentIntel)
		local newIntel = currentIntel + intelAmount
		intelRemote:FireClient(player, newIntel, studyName)
		return newIntel
	end)
end

-- ============================= KNOWLEDGE SECTION ============================= --

function DataUpdater.checkKnowledge(player: Player)
	local intel = PlayerDataHandler:Get(player, "Intelligence")
	local knowledge = PlayerDataHandler:Get(player, "Knowledge")
	local eventsFired = PlayerDataHandler:Get(player, "EventsFired")

	if intel >= 100 and not knowledge.Cultivation then
		knowledge.Cultivation = true
		UnlockCultivation:FireClient(player)
	elseif knowledge.Cultivation then
		UnlockCultivation:FireClient(player)
	end

	if intel >= 200 and not knowledge.ElementAffinity then
		knowledge.ElementAffinity = true
		UnlockAffinities:FireClient(player)
	elseif knowledge.ElementAffinity then
		UnlockAffinities:FireClient(player)
	end

	if eventsFired.Beaten == true and not knowledge.Training then
		knowledge.Training = true
		UnlockTraining:FireClient(player)
		Beaten:FireClient(player)
	elseif knowledge.Training then
		UnlockTraining:FireClient(player)
	end
end

-- ==============================================================================

function DataUpdater.updateAge(player: Player, ageAmount, ageRemote)
	PlayerDataHandler:Update(player, "Age", function(currentAge)
		local newAge = currentAge + ageAmount
		ageRemote:FireClient(player, newAge)
		return newAge
	end)
end

function DataUpdater.updateLifespan(player: Player, lifespanAmount, lifespanRemote)
	PlayerDataHandler:Update(player, "Lifespan", function(currentLifespan)
		local newLifespan = currentLifespan + lifespanAmount
		lifespanRemote:FireClient(player, newLifespan)
		return newLifespan
	end)
end

function DataUpdater.updateTime(player: Player, timeAmount, timeRemote, ageRemote)
	PlayerDataHandler:Update(player, "Time", function(currentTime)
		currentTime.Hour += timeAmount

		while currentTime.Hour >= 24 do
			currentTime.Hour -= 24
			currentTime.Day += 1
		end

		while currentTime.Day >= 30 do
			currentTime.Day = 1
			currentTime.Month += 1
		end

		while currentTime.Month > 12 do
			currentTime.Month = 1
			currentTime.Year += 1
			DataUpdater.updateAge(player, 1, ageRemote)
		end

		timeRemote:FireClient(player, currentTime, timeAmount)
		return currentTime
	end)
end

return DataUpdater
