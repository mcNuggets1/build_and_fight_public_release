AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/cardboard_box004a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	self:SetHealth(100)
	self.CanExplode = true
	self.Boom = false
end

function ENT:Think()
	if !IsValid(self.Owner) or !self.Owner:Alive() then
		self:Remove()
		return
	end
	if self.Boom then
		self:Explode()
	end
end

function ENT:Explode()
	if !self.CanExplode then return end
	self.CanExplode = false
	self:EmitSound("no/no_explode.mp3")
	timer.Simple(math.Rand(1.4, 2), function()
		if !IsValid(self) or !IsValid(self.Owner) then return end
		self:StopSound("no/no_explode.mp3")
		local pos = self:GetPos()
		local edata = EffectData()
		edata:SetOrigin(pos)
		edata:SetNormal(Vector(0, 0, 1))
		edata:SetEntity(self)
		edata:SetScale(1.5)
		edata:SetRadius(150)
		edata:SetMagnitude(15)
		util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
		util.Effect(self:WaterLevel() > 0 and "WaterSurfaceExplosion" or "Explosion", edata, true, true)
		util.Decal("Scorch", pos, pos - Vector(0, 0, 10), self)
		util.BlastDamage(self, self.Owner, pos, 500, 300)
		util.ScreenShake(pos, 2500, 255, 2.5, 1500)
		self:EmitSound("ambient/explosions/explode_"..math.random(1, 4)..".wav")
		self:Remove()
	end)
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() <= 0 then
		self:Explode()
	end
end

function ENT:PhysicsCollide(data, phys)
	local impulse = -data.Speed * data.HitNormal * 0.4 + (data.OurOldVelocity * -.6)
	phys:ApplyForceCenter(impulse)
end