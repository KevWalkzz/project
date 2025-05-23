local Module = {}

function Module.chooseIndex(rarityTable, luck, chosenRarities)
	local newRarityArray = {}
	local totalWeight = 0

	for index, rarity in pairs(rarityTable) do
		if not chosenRarities[index] then
			local weight = rarity[2]
			local newWeight = weight - luck

			if newWeight < 1 then
				newWeight = weight
			end

			local fraction = (1 / newWeight)
			totalWeight += fraction
			newRarityArray[index] = {fraction}
		end
	end

	if totalWeight == 0 then
		return nil
	end

	local random = Random.new()
	local rnd = random:NextNumber(0, totalWeight)
	local selectedRarity = nil
	local accumulatedWeight = 0

	for index, rarity in pairs(newRarityArray) do
		accumulatedWeight += rarity[1]
		if rnd <= accumulatedWeight then
			selectedRarity = index
			break
		end
	end

	return selectedRarity
end

return Module
