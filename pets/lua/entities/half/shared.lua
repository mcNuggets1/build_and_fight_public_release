ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/zombie/classic_torso.mdl"
	self.ModelScale = 0.6
	self.Particles = "bleeding_zombie"
	self.OffsetAngle = Angle(0, 0, 0)
	self.BaseClass.Initialize(self)
	if SERVER then
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle1.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle2.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle3.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle4.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle5.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle6.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle7.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle8.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle9.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle10.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle11.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle12.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle13.wav", 75, 100, 0.8)
		self:AddRandomPetSound("npc/zombie/zombie_voice_idle14.wav", 75, 100, 0.8)
	end
end

function ENT:UpdatePet(speed, weight)
	local sequence = self:LookupSequence("Idle01")
	if (weight >= 1) then
		sequence = self:LookupSequence("Crawl")
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