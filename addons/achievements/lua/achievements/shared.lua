ACHIEVEMENT_ONEOFF = 1
ACHIEVEMENT_PROGRESS = 2

achievements = achievements or {}
achievements.Path = "achievements"
achievements.Initialized = achievements.Initialized or false

include("sh_config.lua")

local BASE = {}
BASE.Type = ACHIEVEMENT_ONEOFF
BASE.Description = ""
BASE.Icon = "gui/achievements/null.png"
BASE.Target = 0
BASE.DontCount = false -- Doesn't count the achievement to achievements.AchvCount

local categories = achievements.categories or {
	["All"] = {Name = "Alle", Icon = "icon16/asterisk_yellow.png", DisplayOrder = 9999, Achievements = {}}
}
achievements.categories = categories

function achievements.CreateCategory(catname)
	if categories[catname] then
		for _, __ in pairs(categories[catname].Achievements or {}) do
			if !categories[catname].DontCount then
				achievements.AchvCount = achievements.AchvCount - 1
			end

			achievements.TrueAchvCount = achievements.TrueAchvCount - 1
		end
		categories[catname] = nil
	end

	categories[catname] = {Name = catname, Achievements = {}, DontCount = false}
	return categories[catname]
end

function achievements.GetCategories()
	return categories
end

local achvs = {}
achievements.AchvCount = 0
achievements.TrueAchvCount = 0
function achievements.GetAchievement(name)
	return achvs[name or ""]
end

function achievements.GetAchievements()
	return achvs
end

function achievements.GetAchievementCount(ply, hidden)
	local count = 0
	local category_data = achievements.GetCategories()
	local data = achievements.GetPlayerData(Entity(1))
	for id, achv in pairs(achvs) do
		local category = category_data[achv.Category]
		if data[id] and data[id].Completed and category and (hidden or !category.DontCount) then
			count = count + 1
		end
	end

	return count
end

function achievements.HasCategoryAchievement(name, ply)
	local category = achievements.GetCategories()[name]
	if !category then return false end

	if SERVER then
		local data = achievements.GetPlayerData(Entity(1))
		for _, id in pairs(category.Achievements) do
			if data[id] and data[id].Completed then
				return true
			end
		end
	else
		for _, id in pairs(category.Achievements) do
			local data = achievements.GetPlayerData(id)
			if data and data.Completed then
				return true
			end
		end
	end

	return false
end

function achievements.Register(category, id, name, tbl, base)
	category = category.Name
	if !categories[category] then
		ErrorNoHalt(string.format("Initialisierung von Errungenschaft %q fehlgeschlagen! (Ungültige Kategorie)\n", name))
		return
	end
	local o = {}
	setmetatable(o, {__index = BASE})
	table.Merge(o, tbl)
	o.ID = id
	o.Name = name
	o.Category = category
	achvs[id] = o

	if achievements.Initialized then
		o:Initialize()
	end

	if !categories[category].DontCount then
		achievements.AchvCount = achievements.AchvCount + 1
	end

	achievements.TrueAchvCount = achievements.TrueAchvCount + 1

	if categories[category].Hidden then
		o.Hidden = true
	end

	table.insert(categories[category].Achievements, id)
	table.insert(categories["All"].Achievements, id)

	return o
end

if SERVER then
	hook.Add("Initialize", "Achv_Initialize", function()
		achievements.Initialized = true
		for _, o in pairs(achvs) do
			local cat = categories[o.Category]
			if o.Initialize and (cat.Active == nil or cat.Active()) then
				o:Initialize()
			end
		end
	end)

	function BASE:Initialize()
	end

	function BASE:AddPoint(ply, pt)
		pt = pt or 1
		local t = self.Target
		if (!t or (t == 0)) then return end
		local ply_data = achievements.GetPlayerData(ply, self.ID)
		if (!ply_data or ply_data.Completed) then return end
		ply_data.Value = math.Clamp(ply_data.Value + pt, 0, t)
		if (ply_data.Value == t) then
			self:Complete(ply)
			return
		end
		achievements.SetPlayerData(ply, self.ID, ply_data)
	end

	function BASE:SetPoint(ply, pt)
		local t = self.Target
		if (!t or (t == 0)) then return end
		local ply_data = achievements.GetPlayerData(ply, self.ID) or {}
		if ply_data.Completed then return end
		ply_data.Value = math.Clamp(pt, 0, t)
		if (ply_data.Value == t) then
			self:Complete(ply)
			return
		end
		achievements.SetPlayerData(ply, self.ID, ply_data)
	end

	function BASE:GetPoints(ply)
		local ply_data = achievements.GetPlayerData(ply, self.ID) or {}
		return tonumber(ply_data.Value) or 0
	end

	function BASE:Complete(ply)
		if ply:IsBot() then return end
		local ply_data = achievements.GetPlayerData(ply, self.ID) or {}
		if ply_data.Completed then return end
		local data = {Value = self.Target, Completed = true, CompletedOn = os.time()}
		achievements.SetPlayerData(ply, self.ID, data, true)
		if self.Rewards then
			for _,reward in pairs(self.Rewards) do
				if reward["money"] and ply.PS_GivePoints then
					ply:PS_GivePoints(reward["money"])
					timer.Simple(3, function()
						if IsValid(ply) then
							ply:PS_Notify("Du hast durch das Freischalten einer Errungenschaft "..string.Comma(reward["money"]).." "..PS.Config.PointsName.." erhalten.")
						end
					end)
				end
			end
		end
		net.Start("Achv_Unlock")
			net.WriteEntity(ply)
			net.WriteString(self.ID)
		net.Broadcast()
	end
end

local function LoadAchievements()
	local files = file.Find((SERVER and "addons/achievements/lua/achievements" or achievements.Path).."/achv/*", SERVER and "MOD_WRITE" or "LUA")
	for _, file in pairs(files) do
		if SERVER then AddCSLuaFile("achv/"..file) end
		include("achv/"..file)
	end
end

LoadAchievements()