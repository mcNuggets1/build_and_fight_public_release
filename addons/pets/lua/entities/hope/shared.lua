ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/pigeon.mdl"
	self.ModelScale = 1
	self.Particles = "hope_beams"
	self.BaseClass.Initialize(self)
	if CLIENT then
		self:AttachPetParticles("hope_clouds")
	end
	if SERVER then
		self:AddRandomPetSound("npc/crow/alert2.wav")
		self:AddRandomPetSound("npc/crow/alert3.wav")
		self:AddRandomPetSound("npc/crow/pain2.wav")
	end
end

function ENT:UpdatePet(speed, weight)
	local z = self:GetVelocity().z
	local sequence = self:LookupSequence("Fly01")
	if (weight >= 1) and z < 0 then
		sequence = self:LookupSequence("Soar")
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