util.AddNetworkString("SZ_UpdateProtection")

local nt = 0
local function ApplyProtection()
	if nt > CurTime() then return end
	nt = CurTime() + 0.3
	for _,ply in ipairs(player.GetAll()) do
		if (!ply.IsFighter or ply:IsFighter()) and ply:SZ_InsideSafeZone() then
			if (!ply.SZ_Protected and !ply.SZ_EnablingProtection) or ply.SZ_DisablingProtection then
				ply:SZ_EnableProtection(ply.SZ_DisablingProtection and true or false)
			end
		elseif (ply.SZ_Protected and !ply.SZ_DisablingProtection) or ply.SZ_EnablingProtection then
			ply:SZ_DisableProtection(ply.SZ_EnablingProtection and true or false)
		end
	end
end
hook.Add("Think", "SZ_ApplyProtection", ApplyProtection)

local meta = FindMetaTable("Player")
function meta:SZ_UpdateProtection(mode, time)
	net.Start("SZ_UpdateProtection")
		net.WriteInt(mode, 4)
		net.WriteFloat(time)
	net.Send(self)
end

function meta:SZ_EnableProtection(nodelay)
	self:SZ_UpdateProtection(1, CurTime() + SZ.Config.EnableProtectionTime)
	self.SZ_EnablingProtection = true
	self.SZ_DisablingProtection = false
	timer.Create("SZ_ApplyProtection_"..self:EntIndex(), nodelay and 0 or SZ.Config.EnableProtectionTime, 1, function()
		if !IsValid(self) then return end
		self:SZ_UpdateProtection(0, 0)
		self.SZ_Protected = true
		self.SZ_EnablingProtection = false
	end)
end

function meta:SZ_DisableProtection(nodelay)
	self:SZ_UpdateProtection(2, CurTime() + SZ.Config.DisableProtectionTime)
	self.SZ_EnablingProtection = false
	self.SZ_DisablingProtection = true
	timer.Create("SZ_ApplyProtection_"..self:EntIndex(), nodelay and 0 or SZ.Config.DisableProtectionTime, 1, function()
		if !IsValid(self) then return end
		self:SZ_UpdateProtection(3, CurTime())
		self.SZ_Protected = false
		self.SZ_DisablingProtection = false
	end)
end

hook.Add("EntityTakeDamage", "SZ_PreventDamage", function(ply, dmg)
	local att = dmg:GetAttacker()
	if !IsValid(att) then return end
	if ply.SZ_Protected and att != ply then
		return true
	elseif att.SZ_Protected then
		if att.SZ_DisablingProtection then
			att:SZ_UpdateProtection(3, CurTime())
			att.SZ_Protected = false
			att.SZ_DisablingProtection = false
		else
			return true
		end
	end
end)

hook.Add("PlayerSpawn", "SZ_ApplyProtection", function(ply)
	timer.Simple(0, function()
		if !IsValid(ply) then return end
		if ply:SZ_InsideSafeZone() then
			ply:SZ_EnableProtection(true)
		end
	end)
	ply.SZ_Protected = false
	ply.SZ_EnablingProtection = false
	ply.SZ_DisablingProtection = false
	timer.Remove("SZ_ApplyProtection_"..ply:EntIndex())
end)

hook.Add("PlayerDeath", "SZ_RemoveTimer", function(ply)
	ply.SZ_Protected = false
	ply.SZ_EnablingProtection = false
	ply.SZ_DisablingProtection = false
	timer.Remove("SZ_ApplyProtection_"..ply:EntIndex())
end)