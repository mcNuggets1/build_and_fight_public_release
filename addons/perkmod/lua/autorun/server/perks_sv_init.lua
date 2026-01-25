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

hook.Add(GetConVarNumber("mg_mysql") == 1 and "DatabaseInitialized" or "Initialize", "Perks_LoadData", function()
	Query("CREATE TABLE IF NOT EXISTS perkmod (steamid varchar(255) PRIMARY KEY NOT NULL, xp INTEGER NOT NULL, level INTEGER NOT NULL, prestige INTEGER NOT NULL, ap INTEGER NOT NULL, perks TEXT NULL)")

	for _, v in ipairs(player.GetAll()) do
		v:Perks_GetData()
	end
end)

hook.Add("PlayerInitialSpawn", "Perks_Load", function(ply)
	ply:Perks_GetData()
end)

hook.Add("PlayerDisconnected", "Perks_Save", function(ply)
	ply:Perks_SaveData()
end)

local Player = FindMetaTable("Player")
function Player:Perks_GetData()
	self.XP = 0
	self.Level = 1
	self.Prestige = 0
	self.AP = 1
	self.Perks = {}
	local sid = self:SteamID()
	Query("SELECT * FROM perkmod WHERE steamid = '"..sid.."'", function(data)
		if !IsValid(self) then return end
		self.PerkMod_Initialised = true
		if !data or data == "NULL" then
			Query("INSERT INTO perkmod (steamid, xp, level, prestige, ap) VALUES ('"..sid.."', 0, 1, 0, 1)")
			self:SetPerkVar("XP", 0)
			self:SetPerkVar("Level", 1)
			self:SetPerkVar("Prestige", 0)
			self:SetPerkVar("AP", 1)
			self.Perks = {}
			return
		end
		data = data[1]
		local xp = tonumber(data["xp"])
		local lvl = tonumber(data["level"])
		local prestige = tonumber(data["prestige"])
		local ap = tonumber(data["ap"])
		local perks = data["perks"]
		self:SetPerkVar("XP", xp + self.XP)
		self:SetPerkVar("Level", lvl)
		self:SetPerkVar("Prestige", prestige)
		self:SetPerkVar("AP", ap)
		self.Perks = perks and isstring(perks) and util.JSONToTable(perks) or {}
		if table.Count(self.Perks) > 0 then
			net.Start("Perks_TransferClient")
				net.WriteTable(self.Perks)
			net.Send(self)
		end
	end)
end

function Player:Perks_SaveData()
	if !self.PerkMod_Initialised then return end
	local xp = self:GetXP()
	local level = self:GetLevel()
	local prestige = self:GetPrestige()
	local ap = self:GetAP()
	local perks = self.Perks
	Query("UPDATE perkmod SET xp = "..xp..", level = "..level..", prestige = "..prestige..", ap = "..ap..", perks = "..SQLStr(util.TableToJSON(perks)).." WHERE steamid = '"..self:SteamID().."'")
	hook.Run("Perks_OnSaveData", self, xp, level, prestige, ap, perks)
end

PerkMod = PerkMod or {}
function PerkMod.ResetData(ply)
	ply = isstring(ply) and ply or ply:SteamID()
	Query("DELETE FROM perkmod WHERE steamid = '"..ply.."'")
	hook.Run("Perks_OnResetData", ply)
end

concommand.Add("perks_buy", function(p, cmd, args)
	if !PerkConfig.BuyXP then return end
	if !IsValid(p) or !PS then return end
	local amt = tonumber(args[1])
	if !amt then return end
	amt = math.floor(math.max(0, amt))
	local level = p:GetLevel()
	if level >= PerkConfig.MaxLevel then
		p:Perks_SendNotify(1, 5, "Du hast bereits das maximale Level erreicht!")
		return
	end
	local cost = math.ceil(amt * PerkConfig.XPPrice)
	if p:PS_HasPoints(cost) then
		p:AddXP(amt, true)
		p:PS_TakePoints(cost)
		p:Perks_SendNotify(0, 5, "Du hast dir "..string.Comma(amt).." XP für "..string.Comma(cost).." Cash gekauft!")
		hook.Run("Perks_OnBuyXP", p, amt, cost)
	else
		p:Perks_SendNotify(1, 6, "Du kannst dir diese Anzahl an XP nicht leisten, da "..string.Comma(cost).." Cash benötigt werden, während du nur "..string.Comma(p:PS_GetPoints()).." Cash besitzt!")
	end
end)

concommand.Add("perks_resetmaxlevel", function(p)
	if !PerkConfig.AllowEdits then return end
	if !IsValid(p) or p:GetLevel() < PerkConfig.MaxLevel or p:GetPrestige() < PerkConfig.MaxPrestige then return end
	p:SetPerkVar("XP", 0)
	p:SetPerkVar("Level", 80)
end)

concommand.Add("perks_resetlevel", function(p)
	if !PerkConfig.AllowEdits then return end
	if !IsValid(p) or p:GetPrestige() < PerkConfig.MaxPrestige then return end
	p:SetPerkVar("XP", 0)
	p:SetPerkVar("Level", 1)
	p.Perks = {}
	p:Perks_SaveData()
	net.Start("Perks_TransferClient")
		net.WriteTable(p.Perks)
	net.Send(p)
end)

concommand.Add("perks_reset", function(p)
	if !IsValid(p) then return end
	local level = p:GetLevel()
	local max_level = math.min(level, PerkConfig.MaxLevel)
	if (p:GetAP() >= max_level) then p:Perks_SendNotify(1, 4, "Du hast noch keine Aufwertungspunkte ausgegeben!") return end
	p:SetPerkVar("AP", max_level)
	p.Perks = {}
	p:Perks_SaveData()
	net.Start("Perks_TransferClient")
		net.WriteTable(p.Perks)
	net.Send(p)
	p:Perks_SendNotify(0, 5, "Deine vergebenen Aufwertungspunkte wurden zurückerstattet!")
	hook.Run("Perks_OnReset", p)
end)

concommand.Add("perks_resetall", function(p)
	if !IsValid(p) then return end
	p:SetPerkVar("XP", 0)
	p:SetPerkVar("Level", 1)
	p:SetPerkVar("Prestige", 0)
	p:SetPerkVar("AP", 1)
	p.Perks = {}
	p:Perks_SaveData()
	net.Start("Perks_TransferClient")
		net.WriteTable(p.Perks)
	net.Send(p)
	p:ChatPrint("Dein gesamter Charakter-Fortschritt wurde zurückgesetzt!")
	hook.Run("Perks_OnResetAll", p)
end)

util.AddNetworkString("Perks_AddNote")
util.AddNetworkString("Perks_SendNotify")
util.AddNetworkString("Perks_AddPerk")
util.AddNetworkString("Perks_Prestige")
util.AddNetworkString("Perks_TransferClient")

net.Receive("Perks_AddPerk", function(l, ply)
	local perk = net.ReadInt(6)
	if ply:GetAP() > 0 then
		ply:AddPerk(perk)
	else
		ply:Perks_SendNotify(1, 4, "Du hast nicht genügend Aufwertungspunkte um diesen Perk verbessern zu können!")
	end
end)

net.Receive("Perks_Prestige", function(l, ply)
	if !PerkConfig.PrestigeSystem then return end
	if ply:GetLevel() >= PerkConfig.MaxLevel then
		if (ply.Perks_Accepted or 0) > CurTime() then
			ply.Perks_Accepted = 0
			ply:PrestigeUpdate()
			ply:Perks_SendNotify(0, 5, "Du hast dein Prestige um 1 erhöht und dein Level zurückgesetzt!")
		else
			ply.Perks_Accepted = CurTime() + 10
			ply:Perks_SendNotify(0, 6, "Bitte warte: Dein Level wird zurückgesetzt, wenn du diesen Knopf erneut betätigst!")
		end
	else
		ply:Perks_SendNotify(1, 4, "Dein Level ist zu niedrig, um deinen Prestige-Status erhöhen zu können!")
	end
end)

function Player:Perks_SendNotify(typ, leng, str)
	net.Start("Perks_SendNotify")
		net.WriteUInt(typ, 4)
		net.WriteUInt(leng, 8)
		net.WriteString(str)
	net.Send(self)
end

function Player:GetLevel()
	return self.Level or 1
end

function Player:AddLevel(force)
	local level = self:GetLevel()
	if !force and level >= PerkConfig.MaxLevel then
		if !PerkConfig.AllowEdits or !tobool(self:GetInfo("cl_nolvllimit")) then
			self:SetPerkVar("Level", PerkConfig.MaxLevel)
			self:SetPerkVar("XP", level * PerkConfig.XPMultiplier)
			return
		end
	end
	self:SetPerkVar("Level", level + 1)
	local xp = math.max(self:GetXP() - level * PerkConfig.XPMultiplier, 0)
	self:SetPerkVar("XP", 0)
	if xp > 0 then
		self:AddXP(xp, true)
	end
	if level < PerkConfig.MaxLevel then
		self:AddAP()
	end
	timer.Create("Perks_NetworkLevel_"..self:SteamID(), 0, 1, function()
		if !IsValid(self) then return end
		net.Start("Perks_AddNote")
			net.WriteBool(false)
		net.Send(self)
		self:Perks_SaveData()
	end)
	hook.Run("Perks_OnLevelup", self, self:GetLevel())
end

function Player:PrestigeUpdate()
	local prestige = self:GetPrestige()
	self:SetPerkVar("Prestige", prestige + 1)
	self:SetPerkVar("Level", 1)
	self:SetPerkVar("XP", 0)
	self:SetPerkVar("AP", 1)
	self:SetPData("Level", 1)
	self:SetPData("XP", 0)
	self:SetPData("AP", 1)
	self:SetPData("Perks", 0)
	self.Perks = {}
	net.Start("Perks_TransferClient")
		net.WriteTable(self.Perks)
	net.Send(self)
	net.Start("Perks_AddNote")
		net.WriteBool(true)
	net.Send(self)
	self:Perks_SaveData()
	hook.Run("Perks_OnPrestige", self, prestige + 1)
end

function Player:GetXP()
	return self.XP or 0
end

function Player:AddXP(n, force)
	local level = self:GetLevel()
	if !PerkConfig.AllowEdits or !tobool(self:GetInfo("cl_nolvllimit")) then
		if level >= PerkConfig.MaxLevel then return end
	end
	n = math.floor(n)
	if !force then
		if self:HasPerk("Bücherwurm") then
			n = n + math.floor(n * self:GetPerkPercentage("Bücherwurm"))
		end
		n = hook.Run("Perks_AddAdditionalXP", self, n) or n
		n = math.floor(n)
	end
	self:SetPerkVar("XP", self:GetXP() + n)
	if self:GetXP() >= (level * PerkConfig.XPMultiplier) then
		self:AddLevel()
	end
	timer.Create("Perks_NetworkXP_"..self:SteamID(), 0, 1, function()
		if !IsValid(self) then return end
		self:Perks_SaveData()
	end)
	hook.Run("Perks_OnAddXP", self, n)
end

function Player:GetPerks()
	return self.Perks or {}
end

function Player:AddPerk(idx)
	local level = self:GetLevel()
	local max_upgrade = PerkConfig.MaxUpgrade
	local t
	for k, v in ipairs(Perks) do
		if k == idx then
			if level >= v[2] then
				t = true
				break
			else
				self:Perks_SendNotify(1, 6, "Dein Level ist zu niedrig um diesen Perk freizuschalten!")
				return
			end
		end
	end
	if t then
		local f
		local has_perk = self.Perks[idx]
		if has_perk then
			if has_perk >= max_upgrade then
				self:Perks_SendNotify(1, 4, "Du hast diesen Perk bereits maximal verbessert!")
				return
			else
				self.Perks[idx] = has_perk + 1
				f = true
			end
		end
		if !f then
			self.Perks[idx] = 1
		end
		self:RemoveAP()
		net.Start("Perks_TransferClient")
			net.WriteTable(self.Perks)
		net.Send(self)
		self:Perks_SaveData()
		hook.Run("Perks_OnAddPerk", self, idx)
	end
end

function Player:GetAP()
	return self.AP or 0
end

function Player:AddAP()
	self:SetPerkVar("AP", self:GetAP() + 1)
	hook.Run("Perks_OnAddAP", self)
end

function Player:RemoveAP()
	self:SetPerkVar("AP", self:GetAP() - 1)
	hook.Run("Perks_OnRemoveAP", self)
end