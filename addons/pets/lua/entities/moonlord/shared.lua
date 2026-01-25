ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/lordcthulhu814/moonlord/moonlord.mdl"
	self.ModelScale = 0.5
	self.Particles = "moonlord_particles"
	self.BaseClass.Initialize(self)
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end