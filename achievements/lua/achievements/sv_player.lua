util.AddNetworkString("Achv_SendData")
util.AddNetworkString("Achv_Unlock")

local PlayerAchvData = {}
function achievements.GetPlayerData(ply, id)
	local achvdata = PlayerAchvData[ply:SteamID()]	
	if !id then
		return achvdata or {}
	end
	return achvdata and achvdata[id] or {Value = 0, Completed = false, CompletedOn = 0}
end

function achievements.SetPlayerData(ply, id, data, savenow)
	local achvdata = PlayerAchvData[ply:SteamID()]
	if !achvdata then return end
	achvdata[id] = data
	if savenow then
		achievements.DataProvider:SetPlayerAchievement(ply, id, data)
		achievements.UpdateAchievements(id)
	end
	net.Start("Achv_SendData")
		net.WriteInt(1, 16)
		net.WriteString(id)
		net.WriteInt(data.Value, 31)
		net.WriteBit(data.Completed)
		if data.Completed then
			net.WriteInt(data.CompletedOn, 32)
		end
	net.Send(ply)
	hook.Run("achievements_PlayerDataSet", ply, id, data, savenow)
end

function achievements.SavePlayerData(ply)
	local achvdata = PlayerAchvData[ply:SteamID()]
	if !achvdata then return end
	for k, v in pairs(achvdata) do
		achievements.DataProvider:SetPlayerAchievement(ply, k, v)
	end
	achievements.UpdateAchievements()
	hook.Run("achievements_PlayerDataSaved", ply, achvdata)
end

function achievements.LoadPlayerData(ply)
	if !achievements.DataProvider.GetPlayerAchievements then
		ErrorNoHaltWithStack("[Achievements] Missing DataProvider.GetPlayerAchievements?")
		return
	end

	achievements.DataProvider:GetPlayerAchievements(ply, function(data)
		if !IsValid(ply) then return end
		data = data or {}
		PlayerAchvData[ply:SteamID()] = data
		local count = table.Count(data)
		local completed = 0
		net.Start("Achv_SendData")
			net.WriteInt(count, 16)
			for k, v in pairs(data) do
				net.WriteString(k)
				net.WriteInt(v.Value, 31)
				net.WriteBit(v.Completed)
				if v.Completed then
					completed = completed + 1
					net.WriteInt(v.CompletedOn, 32)
				end
			end
		net.Send(ply)
		hook.Run("achievements_PlayerDataInitialized", ply, data, completed, count)
	end)
end

function achievements.UpdateAchievements(achv) -- ToDo: Fix this later so that it doesn't make a query every time. Instead, build a cache and use that.
	if !achv or achv != "__count" then
		achievements.DataProvider:Query("SELECT * from achv" .. (achv and (" WHERE achievement='" .. achv .. "'") or ""), function(data)
			local dataTable = {}
			for _, tbl in ipairs(istable(data) and data or {}) do
				local achv = dataTable[tbl.achievement]
				if !achv then
					achv = {
						completed = 0,
					}
					dataTable[tbl.achievement] = achv
				end
				
				if tbl.completed == "1" then
					achv.completed = achv.completed + 1
				end
			end

			for name, tbl in pairs(dataTable) do
				SetGlobal2Int("Achv_" .. name .. "_count", tbl.completed)
			end
		end)
	else
		achievements.DataProvider:Query("SELECT COUNT(*) from daily_login", function(data) -- ToDo: Separate it from DarkRP so that it can work alone / It shouldn't rely on DarkRP
			if istable(data) and data[1] then
				SetGlobal2Int("Achv_Total", data[1]["COUNT(*)"] or player.GetCount())
			end
		end)
	end
end

hook.Add("PlayerInitialSpawn", "Achv_LoadData", function(ply)
	if ply:IsBot() then return end
	achievements.LoadPlayerData(ply)
	achievements.UpdateAchievements("__count")
end)

hook.Add("PlayerDisconnected", "Achv_SaveData", function(ply)
	if ply:IsBot() then return end
	achievements.SavePlayerData(ply)
	PlayerAchvData[ply:SteamID()] = nil
end)

hook.Add("ShutDown", "Achv_SaveData", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply:IsBot() then continue end
		achievements.SavePlayerData(ply)
		PlayerAchvData[ply:SteamID()] = nil
	end
end)