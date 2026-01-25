AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Hit = {Sound("physics/metal/metal_grenade_impact_hard1.wav"), Sound("physics/metal/metal_grenade_impact_hard2.wav"), Sound("physics/metal/metal_grenade_impact_hard3.wav")}
ENT.FleshHit = {Sound("physics/flesh/flesh_impact_bullet1.wav"), Sound("physics/flesh/flesh_impact_bullet2.wav"), Sound("physics/flesh/flesh_impact_bullet3.wav")}

function ENT:Initialize()
	self:SetModel("models/weapons/tfa_nmrih/w_me_machete.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.Damage = 100
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(2.5)
		phys:SetBuoyancyRatio(2)
	end
end

function ENT:Think()
	self.lifetime = self.lifetime or CurTime() + 60
	if CurTime() > self.lifetime then
		self:Remove()
	end
end

function ENT:Disable()
	self.Disabled = true
	self.lifetime = CurTime() + 60
	timer.Simple(0, function()
		if !IsValid(self) then return end
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetOwner(NULL)
	end)
end

local blade_sound = Sound("weapons/blades/impact.mp3")
function ENT:PhysicsCollide(data, phys)
	local Ent = data.HitEntity
	if !IsValid(Ent) and !Ent:IsWorld() then return end
	if Ent:IsWorld() then
		local tr = util.TraceLine({
			start = data.HitPos,
			endpos = data.HitPos + data.HitNormal,
			filter = self
		})
		if tr.HitSky then return end
	end
	if !self.Disabled and data.Speed > 200 then
		local damagedice = self.Damage * math.Rand(0.9, 1.1)
		if Ent:IsWorld() and self:WaterLevel() < 3 then
			util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal, self)
			self:EmitSound(blade_sound)
			self.NextSound = CurTime() + 0.1
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion(false)
			end
			local angles = self:GetAngles()
			local hitpos = data.HitPos
			local hitnormal = data.HitNormal
			timer.Simple(0, function()
				if !IsValid(self) then return end
				self:SetPos(hitpos - hitnormal * 2)
				self:SetAngles(hitnormal:Angle() + Angle(60, 0, 0))
				if IsValid(phys) then
					phys:EnableMotion(false)
				end
			end)
		elseif IsEntity(Ent) then
			if (Ent:IsPlayer() or Ent:IsNPC() or Ent:IsRagdoll()) then
				local edata = EffectData()
				edata:SetOrigin(data.HitPos)
				util.Effect("BloodImpact", edata, true, true)
				self:EmitSound(self.FleshHit[math.random(#self.FleshHit)])
				self.NextSound = CurTime() + 0.1
				timer.Simple(0, function()
					if !IsValid(self) then return end
					local phys = self:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(data.OurOldVelocity / 4)
					end
				end)
				Ent:TakeDamage(damagedice, self.Owner, self)
			else
				util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal, self)
				self:EmitSound(self.Hit[math.random(#self.Hit)])
				self.NextSound = CurTime() + 0.1
				timer.Simple(0, function()
					if !IsValid(self) then return end
					local phys = self:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(data.OurOldVelocity / 4)
					end
				end)
				Ent:TakeDamage(damagedice / 3, self.Owner, self)
				if Ent:GetClass() == "func_breakable_surf" then
					Ent:Fire("Shatter")
				end
			end
		else
			if (self.NextSound or 0) <= CurTime() then
				self:EmitSound(self.Hit[math.random(#self.Hit)])
			end
			self.NextSound = CurTime() + 0.1
		end
	elseif data.Speed > 100 then
		if (self.NextSound or 0) <= CurTime() then
			self:EmitSound(self.Hit[math.random(#self.Hit)])
		end
		self.NextSound = CurTime() + 0.1
	end
	self:Disable()
end

function ENT:Use(activator)
	if activator:IsPlayer() and !activator:HasWeapon("m9k_machete") then
		self:Remove()
		activator:Give("m9k_machete")
		activator:SelectWeapon("m9k_machete")
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
end