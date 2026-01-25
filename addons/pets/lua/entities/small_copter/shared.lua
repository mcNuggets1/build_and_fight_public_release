ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/gibs/helicopter_brokenpiece_06_body.mdl"
	self.ModelScale = 0.1
	self.Particles = "copter_clouds"
	self.BaseClass.Initialize(self)
	if SERVER then
		self:AddRandomPetSound("npc/turret_floor/retract.wav")
	end
end

function ENT:UpdatePet(speed, weight)
	self:SetAngles(self:GetAngles() + Angle(weight * 20, 0, 0))
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end