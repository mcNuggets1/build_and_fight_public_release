ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/combine_dropship.mdl"
	self.ModelScale = 0.07
	self.OffsetAngle = Angle(0, 0, 0)
	self.Particles = "hover_clouds"
	self.BaseClass.Initialize(self)
end

function ENT:UpdatePet(speed, weight)
	self:SetPlaybackRate(1)
	self:ResetSequence(self:LookupSequence("Idle"))
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end