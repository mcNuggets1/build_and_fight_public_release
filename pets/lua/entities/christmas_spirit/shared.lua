ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = 'models/captainbigbutt/skeyler/hats/santa.mdl'
	self.ModelScale = 0.75
	self.Particles = "christmas_spirit_particles"
	self.OffsetAngle = Angle(0, 0, 0)
	self.BaseClass.Initialize(self)
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end