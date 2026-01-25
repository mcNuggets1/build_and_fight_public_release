AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/drug_mod/the_bottle_of_water.mdl")
ENT.DOES_HIGH = false
ENT.HEALTH = 25

function ENT:DoHighEffect(activator, caller)
	if !activator:IsPlayer() then return end
	self:Soberize(activator)
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() <= 0 then
		self:DestroyDrug()
	end
end

function ENT:DestroyDrug()
	local ed = EffectData()
	ed:SetOrigin(self:GetPos())
	util.Effect("drug_bottle_destroy", ed, true, true)
	self:EmitSound("physics/plastic/plastic_box_break2.wav")
	self:Remove()
end