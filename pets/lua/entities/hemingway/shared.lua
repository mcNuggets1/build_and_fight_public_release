ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/props_c17/statue_horse.mdl"
	self.ModelScale = 0.12
	self.OffsetAngle = Angle(-55, -180, 0)
	self.Particles = "horse_trail"
	self.BaseClass.Initialize(self)
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end