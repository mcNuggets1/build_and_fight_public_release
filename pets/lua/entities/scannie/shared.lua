ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/combine_scanner.mdl"
	self.ModelScale = 0.6
	self.Particles = "scanner_particles"
	self.BaseClass.Initialize(self)
	if SERVER then
		self:AddRandomPetSound("npc/scanner/scanner_alert1.wav")
		self:AddRandomPetSound("npc/scanner/scanner_electric2.wav")
		self:AddRandomPetSound("npc/scanner/scanner_scan1.wav")
		self:AddRandomPetSound("npc/scanner/scanner_scan2.wav")
	end
end

function ENT:UpdatePet(speed, weight)
	local z = self:GetVelocity().z
	local sequence = self:LookupSequence("ragdoll")
	if (weight >= 1) and z < 0 then
		sequence = self:LookupSequence("ragdoll")
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