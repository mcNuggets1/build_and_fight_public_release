ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = 'models/props_c17/oildrum001_explosive.mdl'
	self.ModelScale = 0.3
	self.Particles = "black_drops"
	self.BaseClass.Initialize(self)
end

function ENT:UpdatePet(speed, weight)
	local cur_time = CurTime()
	self:SetAngles(self:GetAngles() + Angle(math.sin(cur_time * Pets.WobbleSpeed) * -8, math.cos(cur_time * Pets.WobbleSpeed) * -8, 0))
end

function ENT:OnPetDeath()
	if SERVER then
		local explode = ents.Create("env_explosion")
		explode:SetPos(self:GetPos())
		explode:SetOwner(self)
		explode:Spawn()
		explode:Activate()
		explode:SetKeyValue("iMagnitude", "1")
		explode:Fire("Explode", 0, 0)
	end
end