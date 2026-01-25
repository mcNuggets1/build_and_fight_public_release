AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/items/ar2_grenade.mdl") 
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	SafeRemoveEntityDelayed(self, self.SmokeDuration)
end

function ENT:CreateParticles()
	self:EmitSound("weapons/smokegrenade/sg_explode.wav", 100, 100)
	local edata = EffectData()
	edata:SetOrigin(self:GetPos())
	edata:SetScale(self.SmokeDuration)
	util.Effect("m9k_released_smoke", edata, true, true)
end