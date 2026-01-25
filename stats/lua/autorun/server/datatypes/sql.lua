local function UseMySQL()
	return MySQLite and MySQLite.isMySQL() or false
end

local function SQLStr(str)
	if UseMySQL() then
		return MySQLite.SQLStr(str)
	else
		return sql.SQLStr(str)
	end
end

local function Query(query, func)
	if UseMySQL() then
		MySQLite.query(query, function(res)
			if func then
				func(res)
			end
		end)
	else
		local res = sql.Query(query)
		if func then
			func(res)
		end
	end
end

local function ManageTable(stats, data)
	stats.TotalKills = tonumber(data.totalkills or 0)
	stats.TotalDeaths = tonumber(data.totaldeaths or 0)
	stats.TotalSuicides = tonumber(data.totalsuicides or 0)
	stats.TotalHeadshots = tonumber(data.totalheadshots or 0)
	stats.TotalProps = tonumber(data.totalprops or 0)
	stats.TotalTools = tonumber(data.totaltools or 0)
	stats.TotalMoney = tonumber(data.totalmoney or 0)
	stats.TotalItems = tonumber(stats.TotalItems or data.totalitems or 0)
	stats.TotalItemsInUse = tonumber(stats.TotalItemsInUse or data.totalitemsinuse or 0)
	stats.TotalLevels = tonumber(stats.TotalLevels or data.totallevels or 0)
	stats.TotalAchievements = tonumber(stats.TotalAchievements or data.totalachievements or 0)
	stats.TotalCrates = tonumber(data.totalcrates or 0)
	stats.TotalUnbox = tonumber(data.totalunbox or 0)
	stats.FirstJoin = tonumber(data.firstjoin or os.time())
	stats.PrivateProfile = tonumber(stats.PrivateProfile or data.private or 0)
end

local function InitStats(ply)
	ply.Stats = ply.Stats or {}
	ply.Stats.Loaded = false
	local sid = ply:SteamID()
	Query("SELECT * FROM stats WHERE steamid = '"..sid.."'", function(data)
		if !IsValid(ply) then return end
		if !data or data == "NULL" then
			Query("INSERT into stats (steamid, totalkills, totaldeaths, totalsuicides, totalheadshots, totalprops, totaltools, totalmoney, totalitems, totalitemsinuse, totallevels, totalachievements, totalcrates, totalunbox, firstjoin, private) VALUES ('"..sid.."', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "..os.time()..", 0)")
		end
		ply.Stats = ply.Stats or {}
		ply.Stats.Loaded = nil
		ManageTable(ply.Stats, data and data[1] or {})
		ply.Stats_Loaded = true
	end)
end

hook.Add(GetConVarNumber("mg_mysql") == 1 and "DatabaseInitialized" or "Initialize", "Stats_InitDatabase", function()
	Query("CREATE TABLE IF NOT EXISTS stats (steamid varchar(255) PRIMARY KEY NOT NULL, totalkills INTEGER NOT NULL, totaldeaths INTEGER NOT NULL, totalsuicides INTEGER NOT NULL, totalheadshots INTEGER NOT NULL, totalprops INTEGER NOT NULL, totaltools INTEGER NOT NULL, totalmoney INTEGER NOT NULL, totalitems INTEGER NOT NULL, totalitemsinuse INTEGER NOT NULL, totallevels INTEGER NOT NULL, totalachievements INTEGER NOT NULL, totalcrates INTEGER NOT NULL, totalunbox INTEGER NOT NULL, firstjoin INTEGER NOT NULL, private INTEGER NOT NULL)")

	for _, v in ipairs(player.GetAll()) do
		if v.TTT_Stats and v.TTT_Stats.Loaded then continue end
		InitStats(v)
	end
end)

hook.Add("PlayerInitialSpawn", "Stats_CreatePlayer", InitStats)

function Stats.ResetData(sid)
	Query("DELETE FROM stats WHERE steamid = '"..sid.."'")
end

function Stats.GetOtherPlayerStats(sid, callback)
	if !sid then return end
	Query("SELECT * FROM stats WHERE steamid = "..SQLStr(sid), function(data)
		if !data then 
			callback()
			return
		end
		local stats = {}
		ManageTable(stats, data[1])
		Query("SELECT totaltime FROM utime WHERE steamid = "..SQLStr(sid), function(time)
			stats.OverrideTime = time and time != "NULL" and time[1].totaltime or 0
			callback(stats)
		end)
	end)
end

local function UpdateStats(ply)
	if !ply.Stats_Loaded then return end
	local sid = ply:SteamID()
	local t = ply.Stats
	Query("UPDATE stats SET totalkills = "..t.TotalKills..", totaldeaths = "..t.TotalDeaths..", totalsuicides = "..t.TotalSuicides..", totalheadshots = "..t.TotalHeadshots..", totalprops = "..t.TotalProps..", totaltools = "..t.TotalTools..", totalmoney = "..t.TotalMoney..", totalitems = "..t.TotalItems..", totalitemsinuse = "..t.TotalItemsInUse..", totallevels = "..t.TotalLevels..", totalachievements = "..t.TotalAchievements..", totalcrates = "..t.TotalCrates..", totalunbox = "..t.TotalUnbox..", private = "..t.PrivateProfile.." WHERE steamid = '"..sid.."'")
end

hook.Add("ScalePlayerDamage", "Stats_DetectHitGroup", function(ply, hitgroup)
	ply.Stats_LastHitgroup = hitgroup
end)

hook.Add("PlayerDeath", "Stats_CountKills", function(ply, _, att)
	local hitgroup = ply.Stats_LastHitgroup
	ply.Stats_LastHitgroup = nil
	if !IsValid(att) or !att:IsPlayer() then return end
	if !ply.Stats then return end
	ply.Stats.TotalDeaths = ply.Stats.TotalDeaths + 1
	if ply == att then
		ply.Stats.TotalSuicides = ply.Stats.TotalSuicides + 1
	else
		att.Stats.TotalKills = att.Stats.TotalKills + 1
		if hitgroup == HITGROUP_HEAD then
			att.Stats.TotalHeadshots = att.Stats.TotalHeadshots + 1
		end
	end
end)

hook.Add("PlayerSpawnedProp", "Stats_CountProps", function(ply)
	if !ply.Stats then return end
	ply.Stats.TotalProps = ply.Stats.TotalProps + 1
end)

hook.Add("CanTool", "Stats_CountProps", function(ply)
	if !ply.Stats then return end
	if (ply.Stats_LastTool or 0) > CurTime() then return end
	ply.Stats_LastTool = CurTime() + 0.25
	ply.Stats.TotalTools = ply.Stats.TotalTools + 1
end)

hook.Add("PS_OnGivePoints", "Stats_CountMoney", function(ply, money, sender)
	if IsValid(sender) then return end
	if !ply.Stats then return end
	ply.Stats.TotalMoney = ply.Stats.TotalMoney + money
end)

local function ManageItems(ply, items)
	local used = 0
	for _, item in pairs(items or ply.PS_Items or {}) do
		if item.Equipped then
			used = used + 1
		end
	end
	ply.Stats.TotalItemsInUse = used
end

hook.Add("PS_OnLoadPlayerData", "Stats_CountItems", function(ply, money, items)
	ply.Stats = ply.Stats or {}
	ply.Stats.TotalItems = table.Count(items)
	ManageItems(ply, items)
end)

hook.Add("PS_OnGiveItem", "Stats_CountItems", function(ply)
	if !ply.Stats then return end
	ply.Stats.TotalItems = ply.Stats.TotalItems + 1
	ManageItems(ply)
end)

hook.Add("PS_OnTakeItem", "Stats_CountItems", function(ply)
	if !ply.Stats then return end
	ply.Stats.TotalItems = ply.Stats.TotalItems - 1
	ManageItems(ply)
end)

hook.Add("Perks_PerkVarChanged", "Stats_CountLevels", function(ply, name, var)
	if name == "Level" then
		if !ply.Stats then return end
		ply.Stats = ply.Stats or {}
		ply.Stats.TotalLevels = var
	end
end)

hook.Add("achievements_PlayerDataInitialized", "Stats_CountAchievements", function(ply, data, completed)
	if !ply.Stats then return end
	ply.Stats = ply.Stats or {}
	ply.Stats.TotalAchievements = completed
end)

hook.Add("achievements_PlayerDataSet", "Stats_CountAchievements", function(ply, id, data)
	if data.Completed then
		if !ply.Stats then return end
		ply.Stats.TotalAchievements = ply.Stats.TotalAchievements + 1
	end
end)

hook.Add("OnPlayerUncratedCrate", "Stats_CountCrates", function(ply)
	if !ply.Stats then return end
	ply.Stats.TotalCrates = ply.Stats.TotalCrates + 1
end)

hook.Add("Unboxing_OnPlayerUnboxedCrate", "Stats_CountUnbox", function(ply)
	if !ply.Stats then return end
	ply.Stats.TotalUnbox = ply.Stats.TotalUnbox + 1
end)

local function SaveStats(ply)
	if ply then
		UpdateStats(ply)
	else
		for _,v in ipairs(player.GetAll()) do
			UpdateStats(v)
		end
	end
end

timer.Create("Stats_Save", 600, 0, function()
	SaveStats()
end)

hook.Add("ShutDown", "Stats_Save", function()
	SaveStats()
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "Stats_Save", function(data)
	local ply = Player(data.userid)
	if !IsValid(ply) then return end
	SaveStats(ply)
end)