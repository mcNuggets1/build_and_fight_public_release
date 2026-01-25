AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_px_planted.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	self.CanExplode = true
	self.TimeLeft = CurTime() + 3
	self:EmitSound("C4.Plant")
end

function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	if self.TimeLeft < CurTime() then
		local pos = self:GetPos()
 		for _,v in ipairs(ents.FindInSphere(pos, 200)) do
			if v:IsPlayer() or v:IsNPC() and v != self then
				local trace = {}
				trace.start = pos
				trace.endpos = v:GetPos()
				trace.filter = {self, ent}
				local tr = util.TraceLine(trace)
				local hit = tr.Hit
				if !tr.Hit then
	 				self:Explosion()
					break
				end
			end
		end
	end
	self:NextThink(CurTime() + 0.1)
	return true
end

function ENT:Explosion()
	if !self.CanExplode then return end
	self.CanExplode = false
	local pos = self:GetPos()
	local edata = EffectData()
	edata:SetOrigin(pos)
	edata:SetNormal(self.Normal and -self.Normal or Vector(0, 0, 1))
	edata:SetEntity(self)
	edata:SetScale(1.25)
	edata:SetRadius(50)
	edata:SetMagnitude(20)
	util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
	if self:WaterLevel() > 0 then
		util.Effect(self:WaterLevel() > 0 and "WaterSurfaceExplosion", edata, true, true)
	end
	util.Decal("Scorch", pos, pos - Vector(0, 0, 10), self)
	util.BlastDamage(self, self.Owner, pos, 200, 250)
	util.ScreenShake(pos, 25, 255, 1, 1250)
	self:EmitSound("ambient/explosions/explode_"..math.random(1, 4)..".wav")
	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:Explosion()
end