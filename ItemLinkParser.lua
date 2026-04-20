EasyReminders.ItemLinkParser = EasyReminders.ItemLinkParser or {}

local ItemLinkParser = EasyReminders.ItemLinkParser

local simpleTypes = {
	itemID = 1,
	enchantID = 2,
	suffixID = 7,
	uniqueID = 8,
	linkLevel = 9,
	specializationID = 10,
	modifiersMask = 11,
	itemContext = 12,
}

function ItemLinkParser:ParseItemLink(link)
	local _, linkOptions = LinkUtil.ExtractLink(link)
	local item = {strsplit(":", linkOptions)}
	local t = {}

	for k, v in pairs(simpleTypes) do
		t[k] = tonumber(item[v])
	end

	for i = 1, 4 do
		local gem = tonumber(item[i+2])
		if gem then
			t.gems = t.gems or {}
			t.gems[i] = gem
		end
	end

	local idx = 13
	local numBonusIDs = tonumber(item[idx])
	if numBonusIDs then
		t.bonusIDs = {}
		for i = 1, numBonusIDs do
			t.bonusIDs[i] = tonumber(item[idx+i])
		end
	end
	idx = idx + (numBonusIDs or 0) + 1

	local numModifiers = tonumber(item[idx])
	if numModifiers then
		t.modifiers = {}
		for i = 1, numModifiers do
			local offset = i*2
			t.modifiers[i] = {
				tonumber(item[idx+offset-1]),
				tonumber(item[idx+offset])
			}
		end
		idx = idx + numModifiers*2 + 1
	else
		idx = idx + 1
	end

	for i = 1, 3 do
		local relicNumBonusIDs = tonumber(item[idx])
		if relicNumBonusIDs then
			t.relicBonusIDs = t.relicBonusIDs or {}
			t.relicBonusIDs[i] = {}
			for j = 1, relicNumBonusIDs do
				t.relicBonusIDs[i][j] = tonumber(item[idx+j])
			end
		end
		idx = idx + (relicNumBonusIDs or 0) + 1
	end

	local crafterGUID = item[idx]
	if #crafterGUID > 0 then
		t.crafterGUID = crafterGUID
	end
	idx = idx + 1

	t.extraEnchantID = tonumber(item[idx])

	return t
end

