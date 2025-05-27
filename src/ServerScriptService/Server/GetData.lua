local GetData = {}
local PlayerDataHandler = require(game.ServerScriptService:WaitForChild("PlayerDataHandler")) :: any

function GetData.Data(player, Data: string, ...: string?): ()
	local results = {}

	table.insert(results, PlayerDataHandler:Get(player, Data))

	for _, extraData in ipairs({ ... }) do
		table.insert(results, PlayerDataHandler:Get(player, extraData))
	end

	return unpack(results)
end

return GetData
