ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/vortigaunt.mdl"
	self.ModelScale = 0.4
	self.Particles = "vorti_smoke"
	self.BaseClass.Initialize(self)
end

function ENT:UpdatePet(speed, weight)
	local sequence = self:LookupSequence("Idle01")
	if (weight >= 1) then
		sequence = self:LookupSequence("Run_all")
	end
	self:SetPlaybackRate(1)
	self:ResetSequence(sequence)
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end