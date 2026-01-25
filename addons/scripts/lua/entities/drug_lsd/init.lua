AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/smile/smile.mdl")
ENT.HEALTH = 40

local function SearchForDarkRPEntity(class)
	for _,v in pairs(DarkRPEntities) do
		if v.ent == class then
			return v.price
		end
	end
	return 0
end

function ENT:DoHighEffect(activator, caller)
	if !activator:IsPlayer() then return end
	activator:SetHealth(activator:Health() / 1.05)
	if (activator:Health() <= 1) then
		activator:Kill()
		return false
	end
end

function ENT:SeizeReward()
	return SearchForDarkRPEntity(self:GetClass()) / 2
end

hook.Add("EntityTakeDamage", "drug_lsd_preventdamage", function(ply, dmg)
	if ply:IsPlayer() and ply:GetDrugVar("drug_lsd_high_end") > CurTime() then
		dmg:ScaleDamage(0.8)
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
	ed:SetScale(1)
	util.Effect("drug_destroy_metalic", ed, true, true)
	self:EmitSound("physics/metal/metal_box_impact_bullet1.wav")
	self:Remove()
end