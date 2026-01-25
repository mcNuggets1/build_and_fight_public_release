AddCSLuaFile("unboxing_subconfig.lua")
AddCSLuaFile("unboxing_config.lua")

include("unboxing_config.lua")

util.AddNetworkString("Unbox_InitSpin")
util.AddNetworkString("Unbox_BuyKey")
util.AddNetworkString("Unbox_BuyCrate")
util.AddNetworkString("Unbox_OpenCrate")
util.AddNetworkString("Unbox_FinishedUnbox")
util.AddNetworkString("Unbox_GiftCrate")
util.AddNetworkString("Unbox_GiftKey")
util.AddNetworkString("Unbox_SomeoneGiftedCrate")
util.AddNetworkString("Unbox_SomeoneGiftedKey")
util.AddNetworkString("Unbox_OpenCrateGift")
util.AddNetworkString("Unbox_Found")
util.AddNetworkString("Unbox_SomeoneFoundGift")
util.AddNetworkString("Unbox_Update")

local function UseMySQL()
	return MySQLite and MySQLite.isMySQL() or false
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

hook.Add(GetConVarNumber("mg_mysql") == 1 and "DatabaseInitialized" or "Initialize", "Unbox_InitDatabase", function()
	Query("CREATE TABLE IF NOT EXISTS unboxing (steamid varchar(255) PRIMARY KEY NOT NULL, `keys` INTEGER NOT NULL, crates INTEGER NOT NULL)")
end)

local meta = FindMetaTable("Player")
function meta:InitPlayer()
	Query("INSERT INTO unboxing (steamid, `keys`, crates) VALUES ('"..self:SteamID().."', 0, 0)")
end

function meta:SaveUnbox()
	if !self.unboxing.init then return end
	Query("UPDATE unboxing SET `keys` = "..self.unboxing.keys..", crates = "..self.unboxing.crates.." WHERE steamid = '"..self:SteamID().."'")
end

function meta:LoadUnbox(callback)
	Query("SELECT `keys`, crates FROM unboxing WHERE steamid = '"..self:SteamID().."'", function(data)
		if !IsValid(self) then return end
		if !data then callback() return end
		callback(data[1])
	end)
end

function Unbox_ResetPlayer(ply)
	ply = isstring(ply) and ply or ply:SteamID()
	Query("DELETE FROM unboxing WHERE steamid = '"..ply.."'")
end

net.Receive("Unbox_FinishedUnbox", function(len, ply)
	if ply.unboxing.CurrentlyWaiting then
		ply.unboxing.CurrentlyWaiting = false
		local players = player.GetAll()
		local IsGift = ply.unboxing.IsGift
		local target
		if IsGift then
			local gifts = {}
			for _,v in ipairs(players) do
				if v != ply then
					table.insert(gifts, v)
				end
			end
			if #gifts > 0 then
				target = gifts[math.random(#gifts)]
			else
				ply:ChatPrint("Du bist der einzige Spieler auf dem Server, daher behältst du den Gewinn selbst.")
				target = ply
			end
		end
		local item = ply.unboxing.items[6]
		hook.Run("Unboxing_OnPlayerUnboxedCrate", ply, item, IsGift, target)
		if !item then ply:ChatPrint("Du hast nichts gezogen!\nEigentlich ist das ein Bug, aber wir tun mal so, als wäre es ein Feature!") return end
		if item.Type == "POINTS" then
			if IsGift then
				target:PS_GivePoints(item.Points)
			else
				ply:PS_GivePoints(item.Points)
			end
		elseif item.Type == "PITEM" then
			local giveitem = true
			for _,v in pairs(PS.Items) do
				if item.ItemClassName == v.ID then
					if IsGift then
						if target:PS_HasItem(item.ItemClassName) then
							target:PS_GivePoints(PS.Config.CalculateSellPrice(target, v))
							giveitem = false
							timer.Simple(1, function()
								if IsValid(target) then
									target:PS_Notify("Das Item was dir geschenkt wurde, besitzt du bereits. Es wurde in Geld umgewandelt.")
								end
							end)
						end
					else
						if ply:PS_HasItem(item.ItemClassName) then
							ply:PS_GivePoints(PS.Config.CalculateSellPrice(ply, v))
							giveitem = false
							timer.Simple(1, function()
								if IsValid(ply) then
									ply:PS_Notify("Da du dieses Item bereits besitzt, wurde es in Geld umgewandelt.")
								end
							end)
						end
					end
					if IsGift then
						if v.AllowedUserGroups and #v.AllowedUserGroups > 0 then
							if !table.HasValue(v.AllowedUserGroups, target:PS_GetUsergroup()) then
								target:PS_GivePoints(PS.Config.CalculateSellPrice(target, v))
								giveitem = false
								timer.Simple(1, function()
									if IsValid(target) then
										target:PS_Notify("Das Item was dir geschenkt wurde, ist nur für VIPs. Es wurde in Geld umgewandelt.")
									end
								end)
							end
						end
					else
						if v.AllowedUserGroups and #v.AllowedUserGroups > 0 then
							if !table.HasValue(v.AllowedUserGroups, ply:PS_GetUsergroup()) then
								ply:PS_GivePoints(PS.Config.CalculateBuyPrice(ply, v))
								giveitem = false
								timer.Simple(1, function()
									if IsValid(ply) then
										ply:PS_Notify("Da du kein VIP bist, wurde dein Item in Geld umgewandelt.")
									end
								end)
							end
						end
					end
				end
			end
			if giveitem then
				if IsGift then
					target:PS_GiveItem(item.ItemClassName)
				else
					ply:PS_GiveItem(item.ItemClassName)
				end
			end
		elseif item.Type == "XP" then
			if IsGift then
				target:AddXP(item.XPAmount, true)
			else
				ply:AddXP(item.XPAmount, true)
			end
		elseif item.Type == "KEY" then
			if IsGift then
				target:AddKeys(item.KeyAmount)
			else
				ply:AddKeys(item.KeyAmount)
			end
		end
		if IsGift then
			net.Start("Unbox_SomeoneFoundGift")
				net.WriteEntity(ply)
				net.WriteEntity(target)
				net.WriteString(item.ItemName)
				net.WriteColor(item.ItemColor)
			net.Broadcast()
		else
			net.Start("Unbox_Found")
				net.WriteEntity(ply)
				net.WriteString(item.ItemName)
				net.WriteColor(item.ItemColor)
			net.Broadcast()
		end
	end
end)

function meta:OpenCrate(isgift)
	if self.unboxing.crates > 0 and self.unboxing.keys > 0 and !self.unboxing.CurrentlyWaiting then
		self.unboxing.CurrentlyWaiting = true
		self.unboxing.IsGift = isgift
		self:RemoveKeys(1)
		self:RemoveCrates(1)
		self:SendUnboxSpin()
		hook.Run("Unboxing_OnPlayerBeganUnboxing", self, isgift)
	end
end

net.Receive("Unbox_OpenCrate", function(len, ply)
	ply:OpenCrate(false)
end)

net.Receive("Unbox_OpenCrateGift", function(len, ply)
	ply:OpenCrate(true)
end)

function meta:AddKeys(amount)
	self.unboxing.keys = self.unboxing.keys + amount
	self:SaveUnbox()
	self:SendUnboxUpdate()
end

function meta:RemoveKeys(amount)
	if self.unboxing.keys - amount >= 0 then
		self.unboxing.keys = self.unboxing.keys - amount
	else
		return false
	end
	self:SaveUnbox()
	self:SendUnboxUpdate()
	return true
end

function meta:AddCrates(amount)
	self.unboxing.crates = self.unboxing.crates + amount
	self:SaveUnbox()
	self:SendUnboxUpdate()
end

function meta:RemoveCrates(amount)
	if self.unboxing.crates - amount >= 0 then
		self.unboxing.crates = self.unboxing.crates - amount
	else
		return false
	end
	self:SaveUnbox()
	self:SendUnboxUpdate()
	return true
end

function meta:SendUnboxUpdate()
	net.Start("Unbox_Update")
		net.WriteInt(self.unboxing.keys, 32)
		net.WriteInt(self.unboxing.crates, 32)
	net.Send(self)
end

function meta:GenerateUnboxSpinList()
	local total_chance = 0
	for _,v in pairs(UnboxItems) do
		total_chance = total_chance + v.ItemChance
	end
	local item_list = {}
	for i = 0, 99 do
		local num = math.random(1, total_chance)
		local prev_check = 0
		local item
		for _,v in pairs(UnboxItems) do
			if num >= prev_check and num <= prev_check + v.ItemChance then
				item = v
			end
			prev_check = prev_check + v.ItemChance
		end
		item_list[i] = item
	end
	return item_list
end

function meta:SendUnboxSpin()
	local items = self:GenerateUnboxSpinList()
	self.unboxing.items = items
	net.Start("Unbox_InitSpin")
		net.WriteTable(items)
	net.Send(self)
end

net.Receive("Unbox_BuyKey", function(len, ply)
	local keys = math.Clamp(net.ReadUInt(16), 1, 10)
	local price = UnboxConfig.KeyPrice * keys
	if ply:PS_HasPoints(price) then
		ply:PS_TakePoints(price)
		ply:AddKeys(keys)
		ply:PS_Notify("Du hast "..keys.." Schlüssel gekauft. Viel Glück!")
		hook.Run("Unboxing_OnPlayerBoughtKey", ply, keys, price)
	else
		ply:PS_Notify("Du hast nicht genug Geld!")
	end
end)

net.Receive("Unbox_BuyCrate", function(len, ply)
	local crates = math.Clamp(net.ReadUInt(16), 1, 10)
	local price = UnboxConfig.CratePrice * crates
	if ply:PS_HasPoints(price) then
		ply:PS_TakePoints(price)
		ply:AddCrates(crates)
		ply:PS_Notify("Du hast "..(crates == 1 and "1 Kiste" or crates.." Kisten").." gekauft. Viel Glück!")
		hook.Run("Unboxing_OnPlayerBoughtCrate", ply, crates, price)
	else
		ply:PS_Notify("Du hast nicht genug Geld!")
	end
end)

net.Receive("Unbox_GiftKey", function(len, ply)
	local target = net.ReadEntity()
	if !IsValid(target) or !target:IsPlayer() then return end
	if ply == target then return end
	local keys = math.Clamp(net.ReadUInt(16), 1, 10)
	if ply:RemoveKeys(keys) then
		target:AddKeys(keys)
		target:ChatPrint("Du hast "..keys.." Schlüssel von "..ply:Name().." erhalten.")
		net.Start("Unbox_SomeoneGiftedKey")
			net.WriteEntity(ply)
			net.WriteEntity(target)
			net.WriteUInt(keys, 16)
		net.Broadcast()
		ServerLog(ply:Name().." ("..ply:SteamID()..") gifted "..target:Name().." "..keys.." key(s)\n")
		hook.Run("Unboxing_OnPlayerGiftedKey", ply, target, keys)
	end
end)

net.Receive("Unbox_GiftCrate", function(len, ply)
	local target = net.ReadEntity()
	if !IsValid(target) or !target:IsPlayer() then return end
	if ply == target then return end
	local crates = math.Clamp(net.ReadUInt(16), 1, 10)
	if ply:RemoveCrates(crates) then
		target:AddCrates(crates)
		target:ChatPrint("Du hast "..(crates == 1 and "1 Kiste" or crates.." Kisten").." von "..ply:Name().." bekommen.")
		net.Start("Unbox_SomeoneGiftedCrate")
			net.WriteEntity(ply)
			net.WriteEntity(target)
			net.WriteUInt(crates, 16)
		net.Broadcast()
		ServerLog(ply:Name().." ("..ply:SteamID()..") gifted "..target:Name().." "..crates.." chest(s)\n")
		hook.Run("Unboxing_OnPlayerGiftedCrate", ply, target, crates)
	end
end)

hook.Add("PlayerSay", "Unbox_UseCommand", function(ply, text)
	text = string.lower(text)
	if text == "!unbox" or text == "/unbox" then
		ply:ConCommand("unboxing")
		return ""
	end
end)

hook.Add("PlayerInitialSpawn", "Unbox_Init", function(ply)
	ply.unboxing = {}
	ply.unboxing.crates = 0
	ply.unboxing.keys = 0
	ply:LoadUnbox(function(data)
		if data then
			ply.unboxing.crates = data.crates + ply.unboxing.crates
			ply.unboxing.keys = data.keys + ply.unboxing.keys
		else
			ply:InitPlayer()
		end
		ply.unboxing.init = true
		ply:SendUnboxUpdate()
	end)
end)

concommand.Add("unboxing_reset", function(ply)
	if !IsValid(ply) then return end
	ply.unboxing = {}
	ply.unboxing.init = true
	ply.unboxing.crates = 0
	ply.unboxing.keys = 0
	ply:SendUnboxUpdate()
	ply:SaveUnbox()
end)

local CheckTimer = 0
local CrateTimer = UnboxConfig.CrateTimer * 60
local KeyTimer = UnboxConfig.KeyTimer * 60
local function FreeStuffTimer()
	local curtime = CurTime()
	if curtime > CheckTimer then
		CheckTimer = curtime + 10
		local ply_count = player.GetCount()
		if ply_count >= UnboxConfig.MinPlayers then
			if UnboxConfig.ShouldGiveRandomCrates and CrateTimer < curtime then
				local gifts = {}
				for i=1, math.ceil(ply_count / UnboxConfig.PlayerDivide * math.Rand(0.75, 1.25)) do
					local ply = player.GetAll()[math.random(ply_count)]
					if ply.GetForceSpec and ply:GetForceSpec() then continue end
					gifts[ply:UserID()] = ply
					ply.Crates = ply.Keys and ply.Keys + 1 or 1
				end
				for _,v in pairs(gifts) do
					v:AddCrates(v.Crates)
					v:ChatPrint("Du hast "..(v.Crates > 1 and v.Crates.." Kisten" or v.Crates.." Kiste").." erhalten. Herzlichen Glückwunsch!")
					v.Crates = 0
					ServerLog(v:Name().." ("..v:SteamID()..") received a chest to unbox\n")
					hook.Run("Unboxing_OnPlayerReceivedFreeCrate", v)
				end
				CrateTimer = curtime + (UnboxConfig.CrateTimer * 60)
			end
			if UnboxConfig.ShouldGiveRandomKeys and KeyTimer < curtime then
				local gifts = {}
				for i=1, math.ceil(ply_count / UnboxConfig.PlayerDivide * math.Rand(0.75, 1.25)) do
					local ply = player.GetAll()[math.random(ply_count)]
					if ply.GetForceSpec and ply:GetForceSpec() then continue end
					gifts[ply:UserID()] = ply
					ply.Keys = ply.Keys and ply.Keys + 1 or 1
				end
				for _,v in pairs(gifts) do
					v:AddKeys(v.Keys)
					v:ChatPrint("Du hast "..v.Keys.." Schlüssel erhalten. Herzlichen Glückwunsch!")
					v.Keys = 0
					ServerLog(v:Name().." ("..v:SteamID()..") received a chest key\n")
					hook.Run("Unboxing_OnPlayerReceivedFreeKey", v)
				end
				KeyTimer = curtime + (UnboxConfig.KeyTimer * 60)
			end
		else
			CrateTimer = curtime + (UnboxConfig.CrateTimer * 60)
			KeyTimer = curtime + (UnboxConfig.KeyTimer * 60)
		end
	end
end
hook.Add("Think", "Unbox_FreeStuffTimer", FreeStuffTimer)