AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/maxofs2d/hover_classic.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)  
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	timer.Simple(0.3, function()
		if IsValid(self) then
			self:Explosion()
		end
	end)
end

function ENT:Explosion()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	local pos = self:GetPos()
	local edata = EffectData()
	edata:SetOrigin(pos)
	edata:SetNormal(self.Normal and -self.Normal or Vector(0, 0, 1))
	edata:SetEntity(self)
	edata:SetScale(1.2)
	edata:SetRadius(50)
	edata:SetMagnitude(self.MatType or 20)
	util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
	if self:WaterLevel() > 0 then
		local edata = EffectData()
		edata:SetOrigin(pos)
		util.Effect("WaterSurfaceExplosion", edata, true, true)
	end
	util.BlastDamage(self, self.Owner, pos, 175, 150)
	util.ScreenShake(pos, 25, 255, 1, 2500)
	util.Decal("Scorch", pos, pos + (self.Normal and self.Normal or Vector(0, 0, 1)) * 25, self)
	sound.Play("ambient/explosions/explode_7.wav", pos, 95)
	self:Remove()
end