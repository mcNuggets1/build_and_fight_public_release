ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/props/cs_office/snowman_face.mdl"
	self.ModelScale = 0.8
	self.OffsetAngle = Angle(0, -90, 0)
	self.Particles = "snow_flakes"
	self.BaseClass.Initialize(self)
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end