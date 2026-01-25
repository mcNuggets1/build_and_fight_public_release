PerkMod = PerkMod or {}

local cnt = 1
function PerkMod.AddPerk(name, lvl, perc, desc)
	Perks[cnt] = {name, lvl, perc, desc}
	cnt = cnt + 1
end

PerkMod.SortedPerks = {}

timer.Simple(0, function()
	for k, v in pairs(Perks) do
		PerkMod.SortedPerks[string.lower(v[1])] = {k, v}
	end
end)

local Player = FindMetaTable("Player")
function Player:HasPerk(str)
	str = string.lower(str)
	local idx
	local exists = PerkMod.SortedPerks[str]
	if exists then
		idx = exists[1]
	end
	local perktable = PlayerPerks
	if SERVER then
		perktable = self.Perks
	end
	local perk = perktable[idx]
	if perk then
		return true
	end
	return false
end

function Player:GetPerkPercentage(str, b)
	str = string.lower(str)
	local exists = PerkMod.SortedPerks[str]
	if exists then
		local mult = hook.Run("Perks_PerkPercentageMultiplier", self, str, b)
		return self:GetPerkLevelMultiplier(exists[1], tonumber(exists[2][3]) / 100, b) * (mult or 1)
	end
	return 0
end

function Player:GetPerkLevelMultiplier(num, perc, b)
	perc = perc / PerkConfig.MaxUpgrade
	local perktable = PlayerPerks
	if SERVER then
		perktable = self.Perks
	end
	local n = 0
	if b then
		n = 1
	end
	local prestige = self:GetPrestige()
	local perk = perktable[num]
	if perk then
		if perk >= PerkConfig.MaxUpgrade then
			n = 0
		end
		return (perc * (perk + n)) * (1 + (prestige * PerkConfig.PrestigeMultiplier / 100))
	end
	perk = Perks[num]
	if perk then
		return (perc * n) * (1 + (prestige * PerkConfig.PrestigeMultiplier / 100))
	end
	return 0
end

function Player:GetPrestige()
	return SERVER and (self.Prestige or 0) or (self:GetPerkVar("Prestige") or 0)
end

if SERVER then
	util.AddNetworkString("Perks_UpdateVar")
	function Player:SetPerkVar(name, var)
		self[name] = var
		net.Start("Perks_UpdateVar")
			net.WriteString(name)
			net.WriteInt(var, 32)
		net.Send(self)
		hook.Run("Perks_PerkVarChanged", self, name, var)
	end
end

if CLIENT then
	PerkMod.LocalTable = {}
	net.Receive("Perks_UpdateVar", function(len, ply)
		local name = net.ReadString()
		local num = net.ReadInt(32)
		PerkMod.LocalTable[name] = num
	end)
end

function Player:GetPerkVar(name)
	return SERVER and self[name] or CLIENT and PerkMod.LocalTable[name] or 0
end