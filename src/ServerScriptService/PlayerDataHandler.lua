local PlayerDataHandler = {}

local dataTemplate = {
	Health = 100,
	Stamina = 10,
	MaxStamina = 10,
	Bronze = 0,
	Silver = 0,
	Gold = 0,
	Jade = 0,
	Age = 18,
	Lifespan = 60,
	Time = {
		Hour = 0,
		Day = 1,
		Month = 1,
		Year = 0,
	},
	Strength = 0,
	Endurance = 0,
	Speed = 0,
	Intelligence = 0,
	Qi = 0,
	SpiritStones = 0,
	Luck = 0,
	MinAffinities = 1,
	MaxAffinities = 10,
	Deaths = 0,
	EventsFired = {
		Exploring = 0,
		Beaten = false,
	},
	Knowledge = {
		Training = false,
		Races = false,
		Cultivation = false,
		ElementAffinity = false,
	},
	Affinities = {},
	Realm = {
		Name = "Mortal",
		Stage = "Weak",
	},
	Skills = {
		Punch = {
			Name = "Punch",
			Damage = 1,
			Unlocked = true,
		},
		Kick = {
			Name = "Kick",
			Damage = 2,
			Unlocked = false,
		},
	},
}

local ProfileService = require(game.ServerScriptService.ProfileService)
local Players = game:GetService("Players")

local ProfileStore = ProfileService.GetProfileStore("PlayerProfile61", dataTemplate)

local Profiles = {}

local function playerAdded(player): ()
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function(): ()
			Profiles[player] = nil
			player:Kick("Your profile has been loaded remotely. Please rejoin.")
		end)
		if not player:IsDescendantOf(Players) then
			profile:Release()
		else
			Profiles[player] = profile

			print(Profiles[player].Data)
		end
	else
		player:Kick("Unable to load saved data. Please rejoin.")
	end
end

function PlayerDataHandler:Init(): ()
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(playerAdded, player)
	end

	Players.PlayerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(function(player): ()
		if Profiles[player] then
			Profiles[player]:Release()
		end
	end)
end

local function getProfile(player): ()
	assert(Profiles[player], string.format("Profile does not exist for %s", player.UserId))

	return Profiles[player]
end

-- Getter/Setter Methods
function PlayerDataHandler:Get(player, key): ()
	local maxRetries = 100
	local retries = 0

	while not Profiles[player] and retries < maxRetries do
		task.wait(0.1)
		retries += 1
		if retries >= maxRetries then
			player:Kick("Unable to load profile, rejoin.")
		end
	end

	local profile = getProfile(player)
	assert(profile.Data[key], string.format("Data does not exist for key: %s", key))

	return profile.Data[key]
end

function PlayerDataHandler:Set(player, key, value): ()
	local profile = getProfile(player)
	assert(profile.Data[key], string.format("Data does not exist for key: %s", key))

	assert(type(profile.Data[key]) == type(value), string.format("Data types do not match for key: %s", key))

	profile.Data[key] = value
end

function PlayerDataHandler:Update(player, key, callback): ()
	local _profile = getProfile(player)

	local oldData = self:Get(player, key)
	local newData = callback(oldData)

	self:Set(player, key, newData)
end

return PlayerDataHandler
