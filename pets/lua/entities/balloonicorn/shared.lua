ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = 'models/gmod_tower/balloonicorn_nojiggle.mdl'
	self.ModelScale = 0.7
	self.Particles = "balloonicorn_particles"
	self.OffsetAngle = Angle(0, 90, 90)
	self.BaseClass.Initialize(self)
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end