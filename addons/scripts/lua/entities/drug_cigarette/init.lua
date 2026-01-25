AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/boxopencigshib.mdl")
ENT.HEALTH = 10

function ENT:DoHighEffect(activator,caller)
	if !activator:IsPlayer() then return end
	activator:SetHealth(activator:Health() / 1.03)
	if (activator:Health() <= 1) then
		activator:Kill()
		return false
	end
end

hook.Add("EntityTakeDamage", "drug_cigarette_preventdamage", function(ply, dmg)
	local att = dmg:GetAttacker()
	if att:IsPlayer() and att:GetDrugVar("drug_cigarette_high_end") > CurTime() then
		dmg:ScaleDamage(1.1)
	end
end)

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
	ed:SetRadius(0)
	util.Effect("drug_destroy", ed, true, true)
	self:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav", 75, 100, 0.7)
	self:Remove()
end