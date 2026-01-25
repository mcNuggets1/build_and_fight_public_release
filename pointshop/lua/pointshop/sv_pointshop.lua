net.Receive("PS_AskForInformation", function(len, ply)
	if ply.PS_Initialized or ply.PS_QueueForInitialize then return end
	ply.PS_Initialized = true
	if !ply.PS_FirstLoadCompleted then
		ply.PS_QueueForInitialize = true
	else
		ply:PS_SendAll()
	end
end)

net.Receive("PS_BuyItem", function(len, ply)
	ply:PS_BuyItem(net.ReadString())
end)

net.Receive("PS_SellItem", function(len, ply)
	ply:PS_SellItem(net.ReadString())
end)

net.Receive("PS_EquipItem", function(len, ply)
	ply:PS_EquipItem(net.ReadString())
end)

net.Receive("PS_HolsterItem", function(len, ply)
	ply:PS_HolsterItem(net.ReadString())
end)

net.Receive("PS_ModifyItem", function(len, ply)
	ply:PS_ModifyItem(net.ReadString(), net.ReadTable())
end)

net.Receive("PS_GiftPoints", function(len, ply)
	local other = net.ReadEntity()
	local points = net.ReadUInt(32)
	points = math.ceil(points)
	if PS.Config.CanPlayersGivePoints and points > 0 and IsValid(other) and other:IsPlayer() and ply:PS_HasPoints(points) then
		if PS.Config.CanPlayersGivePointsUTime and ply.GetUTimeTotalTime and ply:GetUTimeTotalTime() < PS.Config.CanPlayersGivePointsUTime then
			ply:PS_Notify("Du benötigst eine Mindestspielzeit von "..(PS.Config.CanPlayersGivePointsUTime / 60 / 60).." Stunden, um anderen Spielern, Cash zu senden!")
			return
		end
		ply:PS_TakePoints(points)
		ply:PS_Notify("Du hast "..other:Name().." "..string.Comma(points).." "..PS.Config.PointsName.." gesendet.")
		other:PS_GivePoints(points, ply)
		other:PS_Notify(ply:Name().." hat dir "..string.Comma(points).." "..PS.Config.PointsName.." gesendet.")
		ServerLog("[PS] "..ply:Name().." sent "..other:Name().." "..string.Comma(points).." "..PS.Config.PointsName.."\n")
	end
end)

net.Receive("PS_GivePoints", function(len, ply)
	if !PS.Config.AdminCanAccessAdminTab and !PS.Config.SuperAdminCanAccessAdminTab then return end
	local other = net.ReadEntity()
	local points = net.ReadUInt(32)
	points = math.ceil(points)
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	if (admin_allowed or super_admin_allowed) and points > 0 and IsValid(other) and other:IsPlayer() then
		other:PS_GivePoints(points, ply)
		other:PS_Notify(ply:Name().." hat dir "..string.Comma(points).." "..PS.Config.PointsName.." gesendet!")
		ServerLog("[PS Admin] "..ply:Name().." sent "..other:Name().." "..string.Comma(points).." "..PS.Config.PointsName.."\n")
	end
end)

net.Receive("PS_TakePoints", function(len, ply)
	if !PS.Config.AdminCanAccessAdminTab and !PS.Config.SuperAdminCanAccessAdminTab then return end
	local other = net.ReadEntity()
	local points = net.ReadUInt(32)
	points = math.ceil(points)
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	if (admin_allowed or super_admin_allowed) and points > 0 and IsValid(other) and other:IsPlayer() then
		other:PS_TakePoints(points, ply)
		other:PS_Notify(ply:Name().." hat dir "..string.Comma(points).." "..PS.Config.PointsName.." genommen!")
		ServerLog("[PS Admin] "..ply:Name().." took "..string.Comma(points).." "..PS.Config.PointsName.." from "..ply:Name().."\n")
	end
end)

net.Receive("PS_SetPoints", function(len, ply)
	if !PS.Config.AdminCanAccessAdminTab and !PS.Config.SuperAdminCanAccessAdminTab then return end
	local other = net.ReadEntity()
	local points = net.ReadUInt(32)
	points = math.ceil(points)
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	if (admin_allowed or super_admin_allowed) and points >= 0 and IsValid(other) and other:IsPlayer() then
		other:PS_SetPoints(points, ply)
		other:PS_Notify(ply:Name().." hat deinen Geldstand auf "..string.Comma(points).." "..PS.Config.PointsName.." gesetzt.")
		ServerLog("[PS Admin] "..ply:Name().." set "..other:Name().."'s balance to "..string.Comma(points).." "..PS.Config.PointsName.."\n")
	end
end)

net.Receive("PS_GiveItem", function(len, ply)
	if !PS.Config.AdminCanAccessAdminTab and !PS.Config.SuperAdminCanAccessAdminTab then return end
	local other = net.ReadEntity()
	local item_id = net.ReadString()
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	if (admin_allowed or super_admin_allowed) and PS.Items[item_id] and IsValid(other) and other:IsPlayer() and !other:PS_HasItem(item_id) then
		other:PS_GiveItem(item_id, ply)
		other:PS_Notify(ply:Name().." hat dir "..PS.Items[item_id].Name.." gegeben.")
		ServerLog("[PS Admin] "..ply:Name().." gave "..PS.Items[item_id].Name.." to "..other:Name().."\n")
	end
end)

net.Receive("PS_TakeItem", function(len, ply)
	if !PS.Config.AdminCanAccessAdminTab and !PS.Config.SuperAdminCanAccessAdminTab then return end
	local other = net.ReadEntity()
	local item_id = net.ReadString()
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	if (admin_allowed or super_admin_allowed) and PS.Items[item_id] and IsValid(other) and other:IsPlayer() and other:PS_HasItem(item_id) then
		other.PS_Items[item_id].Equipped = false
		local ITEM = PS.Items[item_id]
		ITEM:OnHolster(other)
		other:PS_TakeItem(item_id, ply)
		other:PS_Notify(ply:Name().." hat dir "..PS.Items[item_id].Name.." genommen.")
		ServerLog("[PS Admin] "..ply:Name().." took "..PS.Items[item_id].Name.." from "..other:Name().."\n")
	end
end)

hook.Add("PlayerSpawn", "PS_PlayerSpawn", function(ply)
	ply:PS_PlayerSpawn()
end)

hook.Add("DoPlayerDeath", "PS_DoPlayerDeath", function(ply)
	ply:PS_DoPlayerDeath()
end)

hook.Add("PlayerSilentDeath", "PS_PlayerSilentDeath", function(ply)
	ply:PS_PlayerSilentDeath()
end)

hook.Add("PlayerInitialSpawn", "PS_PlayerInitialSpawn", function(ply)
	ply:PS_PlayerInitialSpawn()
end)

hook.Add("PlayerDisconnected", "PS_PlayerDisconnected", function(ply)
	ply:PS_PlayerDisconnected()
end)

hook.Add("PlayerSay", "PS_PlayerSay", function(ply, text)
	if !ply.PS_FirstLoadCompleted then ply:PS_Notify("Deine Shopdaten sind noch nicht synchronisiert!") return end
	if PS.Config.ShopChatCommand != "" and string.lower(text) == PS.Config.ShopChatCommand then
		ply:PS_ToggleMenu()
		return ""
	end
end)

concommand.Add(PS.Config.ShopCommand, function(ply, cmd, args)
	if !IsValid(ply) then return end
	if !ply.PS_FirstLoadCompleted then ply:PS_Notify("Deine Shopdaten sind noch nicht synchronisiert!") return end
	ply:PS_ToggleMenu()
end)

concommand.Add("shop_reset", function(ply, cmd, args)
	if !IsValid(ply) then return end
	ply:PS_SetPoints(0)
	ply.PS_Items = {}
	ply:PS_NetworkItems()
	ply:PS_Notify("Shop: Dein Inventar und Geld wurde erfolgreich zurückgesetzt.")
end)

util.AddNetworkString("PS_NetworkItems")
util.AddNetworkString("PS_NetworkPoints")
util.AddNetworkString("PS_SendItems")
util.AddNetworkString("PS_SendPoints")
util.AddNetworkString("PS_GiftPoints")
util.AddNetworkString("PS_BuyItem")
util.AddNetworkString("PS_SellItem")
util.AddNetworkString("PS_EquipItem")
util.AddNetworkString("PS_HolsterItem")
util.AddNetworkString("PS_ModifyItem")
util.AddNetworkString("PS_GivePoints")
util.AddNetworkString("PS_TakePoints")
util.AddNetworkString("PS_SetPoints")
util.AddNetworkString("PS_GiveItem")
util.AddNetworkString("PS_TakeItem")
util.AddNetworkString("PS_SendClientsideModel")
util.AddNetworkString("PS_AddClientsideModel")
util.AddNetworkString("PS_RemoveClientsideModel")
util.AddNetworkString("PS_SendClientsideModels")
util.AddNetworkString("PS_SendPlayerClientsideModels")
util.AddNetworkString("PS_SendNotification")
util.AddNetworkString("PS_SendNotice")
util.AddNetworkString("PS_ToggleMenu")
util.AddNetworkString("PS_AskForInformation")

function PS:LoadDataProviders()
	local provider = self.Config.DataProvider
	local path = "pointshop/providers/"..provider..".lua"
	if !file.Exists(path, "LUA") then
		error("Shop: Fehlender Provider. Überprüfe deine angegebenen Daten!")
	end
	PROVIDER = {}
	PROVIDER.__index = {}
	include(path)
	self.DataProvider = PROVIDER
	if PROVIDER.Initialize then
		PROVIDER:Initialize()
	end
	PROVIDER = nil
end

function PS:GetPlayerData(ply, callback)
	self.DataProvider:GetData(ply, function(points, items)
		callback(PS:ValidatePoints(tonumber(points)), PS:ValidateItems(items))
	end)
end

function PS:SetPlayerData(ply, points, items)
	self.DataProvider:SetData(ply, points, items)
end

hook.Add(GetConVarNumber("mg_mysql") == 1 and "DatabaseInitialized" or "Initialize", "PS_InitDatabase", function()
	PS:LoadDataProviders()
	for _, v in ipairs(player.GetAll()) do
		v:PS_LoadData()
	end
end)