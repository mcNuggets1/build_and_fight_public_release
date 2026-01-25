include("unboxing_subconfig.lua")

UnboxConfig.MinPlayers = 6
UnboxConfig.PlayerDivide = 4

UnboxConfig.KeyPrice = 5000
UnboxConfig.CratePrice = 3000

UnboxConfig.ShouldGiveRandomCrates = true
UnboxConfig.CrateTimer = 10

UnboxConfig.ShouldGiveRandomKeys = true
UnboxConfig.KeyTimer = 15

Unbox_AddExtraKey("1 Schlüssel", 1, 2500, Color(255, 100, 61))
Unbox_AddExtraKey("2 Schlüssel", 2, 1000, Color(255, 100, 61))
Unbox_AddExtraKey("3 Schlüssel", 3, 400, Color(255, 100, 61))
Unbox_AddExtraKey("10 Schlüssel", 10, 30, Color(255, 100, 61))

Unbox_AddExperience("5,000 XP", 5000, 1500, Color(103, 207, 105))
Unbox_AddExperience("10,000 XP", 10000, 1000, Color(103, 207, 105))
Unbox_AddExperience("25,000 XP", 25000, 500, Color(103, 207, 105))
Unbox_AddExperience("50,000 XP", 50000, 250, Color(103, 207, 105))
Unbox_AddExperience("100,000 XP", 100000, 100, Color(103, 207, 105))
Unbox_AddExperience("250,000 XP", 250000, 50, Color(103, 207, 105))

Unbox_AddPointShopPoints("1 Cash", 1, 4000, Color(245, 184, 0))
Unbox_AddPointShopPoints("10 Cash", 10, 8000, Color(245, 184, 0))
Unbox_AddPointShopPoints("50 Cash", 50, 7000, Color(245, 184, 0))
Unbox_AddPointShopPoints("100 Cash", 100, 6000, Color(245, 184, 0))
Unbox_AddPointShopPoints("500 Cash", 500, 5000, Color(245, 184, 0))
Unbox_AddPointShopPoints("1,000 Cash", 1000, 4000, Color(245, 184, 0))
Unbox_AddPointShopPoints("5,000 Cash", 5000, 3000, Color(245, 184, 0))
Unbox_AddPointShopPoints("10,000 Cash", 10000, 1000, Color(245, 184, 0))
Unbox_AddPointShopPoints("50,000 Cash", 50000, 150, Color(245, 184, 0))
Unbox_AddPointShopPoints("100,000 Cash", 100000, 40, Color(245, 184, 0))
Unbox_AddPointShopPoints("250,000 Cash", 250000, 10, Color(245, 184, 0))

hook.Add("PS_LoadItems","Unbox:LoadPSItems",function()
	if !PS then return end

	UnboxConfig.RestrictedCategories = {
		["Einmalige Waffen"] = true
	}

	UnboxConfig.GreyItems = 15000
	UnboxConfig.GreenItems = {10000, 8000}
	UnboxConfig.BlueItems = {25000, 3500}
	UnboxConfig.PurpleItems = {50000, 1500}
	UnboxConfig.OrangeItems = {75000, 400}

	local categorise = {}
	for _, item in pairs(PS.Items) do
		if UnboxConfig.RestrictedCategories[item.Category] then continue end
		if item.Price <= 0 then continue end
		if item.UnboxOnly then continue end

		if item.Price >= UnboxConfig.OrangeItems[1] then
			categorise["orange"] = categorise["orange"] or 0
			categorise["orange"] = categorise["orange"] + 1
		elseif item.Price >= UnboxConfig.PurpleItems[1] then
			categorise["purple"] = categorise["purple"] or 0
			categorise["purple"] = categorise["purple"] + 1
		elseif item.Price >= UnboxConfig.BlueItems[1] then
			categorise["blue"] = categorise["blue"] or 0
			categorise["blue"] = categorise["blue"] + 1
		elseif item.Price >= UnboxConfig.GreenItems[1] then
			categorise["green"] = categorise["green"] or 0
			categorise["green"] = categorise["green"] + 1
		else
			categorise["grey"] = categorise["grey"] or 0
			categorise["grey"] = categorise["grey"] + 1
		end
	end

	for _, item in pairs(PS.Items) do
		if UnboxConfig.RestrictedCategories[item.Category] then continue end
		if item.Price <= 0 then continue end
		if item.Hidden then continue end

		local color, model, disp, chance

		if item.UnboxOnly then
			color = Color(168, 50, 50)
			chance = math.floor(math.max(item.UnboxOnly, 1))
		elseif item.Price >= UnboxConfig.OrangeItems[1] then
			color = Color(255, 153, 0)
			chance = math.floor(math.max(UnboxConfig.OrangeItems[2] / categorise["orange"], 1))
		elseif item.Price >= UnboxConfig.PurpleItems[1] then
			color = Color(153, 0, 153)
			chance = math.floor(math.max(UnboxConfig.PurpleItems[2] / categorise["purple"], 1))
		elseif item.Price >= UnboxConfig.BlueItems[1] then
			color = Color(0, 102, 255)
			chance = math.floor(math.max(UnboxConfig.BlueItems[2] / categorise["blue"], 1))
		elseif item.Price >= UnboxConfig.GreenItems[1] then
			color = Color(0, 156, 0)
			chance = math.floor(math.max(UnboxConfig.GreenItems[2] / categorise["green"], 1))
		else
			color = Color(92, 92, 92)
			chance = math.floor(math.max(UnboxConfig.GreyItems / categorise["grey"], 1))
		end

		if item.Material then
			disp = item.Material
		elseif item.Model then
			model = true
			disp = item.Model
		else
			disp = "materials/unboxing/trail.png"
		end
	
		Unbox_AddPointShopItem(item.Name, item.ID, model, disp, item.Category, item.Price, color, chance)
	end
end)