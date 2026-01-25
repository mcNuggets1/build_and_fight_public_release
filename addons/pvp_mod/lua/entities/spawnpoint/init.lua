AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("Spawnpoint_OpenMenu")
util.AddNetworkString("Spawnpoint_AddPlayer")
util.AddNetworkString("Spawnpoint_RemovePlayer")

function ENT:SpawnFunction(ply, tr, ClassName)
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 4
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	local ent = ents.Create(ClassName)
	if !IsValid(ent) then return end
	ent:SetPos(SpawnPos)
	ent:SetAngles(SpawnAng)
	ent:Spawn()
	ent:Activate()
	return ent
end

net.Receive("Spawnpoint_AddPlayer", function(len, ply)
	if !ply:Alive() then return end
	local ply2 = net.ReadEntity()
	local ent = net.ReadEntity()
	if !IsValid(ply2) or !ply2:IsPlayer() or !IsValid(ent) or ent:GetClass() != "spawnpoint" then return end
	if ent.CPPIGetOwner and ent:CPPIGetOwner() != ply then return end
	if ply == ply2 then
		if ply:IsFighter() then PVP.SendNotify(ply, 1, 4, "Du musst Builder sein, um deinen Spawnpoint setzen zu können!") return end
		ent:CastUseEffect()
		PVP.SendNotify(ply, 0, 3, "Spawnpoint gesetzt.")
		ply.Spawnpoint = ent
	end
	ent.Players[ply2] = ply2
end)

net.Receive("Spawnpoint_RemovePlayer", function(len, ply)
	if !ply:Alive() then return end
	local ply2 = net.ReadEntity()
	local ent = net.ReadEntity()
	if !IsValid(ply2) or !ply2:IsPlayer() or !IsValid(ent) or ent:GetClass() != "spawnpoint" then return end
	if ent.CPPIGetOwner and ent:CPPIGetOwner() != ply then return end
	if ply == ply2 then
		ent:CastUseEffect()
		PVP.SendNotify(ply, 1, 3, "Spawnpoint entfernt.")
		ply.LastSpawnpointUsed = {spawn = ent, time = CurTime() + 180}
		ply.Spawnpoint = nil
	end
	if ply2.Spawnpoint == ent then
		ply2.Spawnpoint = nil
	end
	ent.Players[ply2] = nil
end)

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_mine01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	self:SetHealth(1000)
	self.CanExplode = true
	self.Players = {}
	self:CastSpawnEffect()
end

hook.Add("PhysgunDrop", "Spawnpoint_PhysgunDrop", function(ply, ent)
	if IsValid(ent) and ent:GetClass() == "spawnpoint" then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end)

hook.Add("CanPlayerUnfreeze", "Spawnpoint_CanPlayerUnfreeze", function(ply, ent)
	if IsValid(ent) and ent:GetClass() == "spawnpoint" then
		return false
	end
end)

function ENT:OnRemove()
	if self.RewardMoney and !self.Rewarded then
		local ply = self.LastDamaged
		if IsValid(ply) and ply:IsFighter() and self.LastDamageTime > CurTime() and (!self.CPPIGetOwner or self:CPPIGetOwner() != ply) and (!ply.LastSpawnpointUsed or ply.LastSpawnpointUsed.spawn != self or ply.LastSpawnpointUsed.time < CurTime()) and ply.Spawnpoint != self then
			local reward = math.ceil(self.RewardMoney)
			if ply.MG_AddMoney then
				ply:MG_AddMoney(reward)
			else
				ply:PS_GivePoints(reward)
			end
			local name = self.CPPIGetOwner and IsValid(self:CPPIGetOwner()) and self:CPPIGetOwner():IsPlayer() and self:CPPIGetOwner():Name() or "Unbekannt"
			ply:PS_Notify("Du hast "..reward.." Cash für das zuvorige Beschädigen des Spawnpoints von "..name.." erhalten.")
		else
			local valueplayers = {}
			for _,ply in ipairs(player.GetAll()) do
				if ply:IsFighter() and (!self.CPPIGetOwner or self:CPPIGetOwner() != ply) and (!ply.LastSpawnpointUsed or ply.LastSpawnpointUsed.spawn != self or ply.LastSpawnpointUsed.time < CurTime()) and ply.Spawnpoint != self then
					table.insert(valueplayers, ply)
				end
			end
			local name = self.CPPIGetOwner and IsValid(self:CPPIGetOwner()) and self:CPPIGetOwner():IsPlayer() and self:CPPIGetOwner():Name() or "Unbekannt"
			local reward = math.ceil(self.RewardMoney / #valueplayers)
			for _,ply in ipairs(valueplayers) do
				if ply.MG_AddMoney then
					ply:MG_AddMoney(reward)
				else
					ply:PS_GivePoints(reward)
				end
				ply:PS_Notify("Du hast "..string.Comma(reward).." Cash als Beteiligung für die Beseitigung des Spawnpoints von "..name.." erhalten.")
			end
		end
		self.Rewarded = true
	end
	self:CastSpawnEffect()
end

function ENT:CastSpawnEffect()
	local edata = EffectData()
	edata:SetOrigin(self:GetPos())
	util.Effect("spawnpoint_start", edata)
end

function ENT:CastUseEffect()
	local edata = EffectData()
	edata:SetOrigin(self:GetPos())
	util.Effect("spawnpoint_use", edata)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() and activator:Alive() then
		if !self.CPPIGetOwner or self:CPPIGetOwner() == activator then
			net.Start("Spawnpoint_OpenMenu")
				net.WriteTable(self.Players)
				net.WriteEntity(self)
			net.Send(activator)
		elseif self.Players[activator] then
			if IsValid(activator.Spawnpoint) and activator.Spawnpoint == self then
				self:CastUseEffect()
				PVP.SendNotify(activator, 1, 3, "Spawnpoint entfernt.")
				activator.Spawnpoint = nil
			elseif activator:IsBuilder() then
				self:CastUseEffect()
				PVP.SendNotify(activator, 0, 3, "Spawnpoint gesetzt.")
				activator.Spawnpoint = self
			else
				PVP.SendNotify(activator, 1, 4, "Du musst Builder sein, um deinen Spawnpoint setzen zu können!")
			end
		else
			PVP.SendNotify(activator, 1, 4, "Du hast keine Erlaubnis, diesen Spawnpoint mitzubenutzen!")
		end
		hook.Run("OnPlayerUsedSpawnpoint", activator)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	local ply = dmginfo:GetAttacker()
	if IsValid(ply) and ply:IsPlayer() and ply:IsFighter() and (!self.CPPIGetOwner or self:CPPIGetOwner() != ply) and (!ply.LastSpawnpointUsed or ply.LastSpawnpointUsed.spawn != self or ply.LastSpawnpointUsed.time < CurTime()) and ply.Spawnpoint != self then
		self.LastDamaged = ply
		self.LastDamageTime = CurTime() + 180
	end
	if self:Health() <= 0 and self.CanExplode then
		self.CanExplode = false
		local pos = self:GetPos()
		util.BlastDamage(self, self, pos, 100, 75)
		util.ScreenShake(pos, 512, 255, 1.25, 256)
		local edata = EffectData()
		edata:SetOrigin(pos)
		util.Effect(self:WaterLevel() > 1 and "WaterSurfaceExplosion" or "Explosion", edata, true, true)
		util.Decal("Scorch", pos, pos - Vector(0, 0, 25), self)
		hook.Run("OnSpawnpointDestroyed", self, dmginfo)
		if self.RewardMoney and IsValid(ply) and ply:IsPlayer() and ply:IsFighter() and (!self.CPPIGetOwner or self:CPPIGetOwner() != ply) and (!ply.LastSpawnpointUsed or ply.LastSpawnpointUsed.spawn != self or ply.LastSpawnpointUsed.time < CurTime()) and ply.Spawnpoint != self then
			self.Rewarded = true
			local reward = math.ceil(self.RewardMoney)
			if ply.MG_AddMoney then
				ply:MG_AddMoney(reward)
			else
				ply:PS_GivePoints(reward)
			end
			ply:PS_Notify("Du hast "..string.Comma(reward).." Cash für das Zerstören eines Spawnpoints erhalten.")
		end
		self:Remove()
	end
end

hook.Add("PlayerSpawn", "Spawnpoint_Usage", function(ply)
	local point = ply.Spawnpoint
	if IsValid(point) then
		ply:SetPos(point:GetPos() + point:GetUp() * 35)
		if NoCollidePlayer then
			NoCollidePlayer(ply, ply:GetPos(), true)
		end
		hook.Run("OnSpawnpointSpawned", ply, point)
	else
		hook.Run("OnNormalSpawned", ply)
	end
end)