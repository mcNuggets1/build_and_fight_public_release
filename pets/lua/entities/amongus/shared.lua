ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/amongus/amongus.mdl"
	self.ModelScale = 0.3
	self.Particles = "amongus_particles"
	self.BaseClass.Initialize(self)
	if SERVER then
		self:AddRandomPetSound("amongus/amongus_vote.wav", 75, 100, 0.8)
	end
end

function ENT:OnPetDeath()
	if SERVER then
		self:EmitSound("amongus/amongus_voted_out.wav", 75, 100, 0.8)
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end