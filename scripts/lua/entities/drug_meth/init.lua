AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/katharsmodels/contraband/metasync/blue_sky.mdl")
ENT.HEALTH = 10

local function SearchForDarkRPEntity(class)
	for _,v in pairs(DarkRPEntities) do
		if v.ent == class then
			return v.price
		end
	end
	return 0
end

function ENT:SeizeReward()
	return SearchForDarkRPEntity(self:GetClass()) / 2
end

function ENT:DoHighEffect(activator, caller)
	if !activator:IsPlayer() then return end
	activator:SetHealth(activator:Health() / 1.15)
	if (activator:Health() <= 1) then
		activator:Kill()
		return false
	end
	sound.Play("drugs/insufflation.wav", activator:GetPos(), 75, 100, 1)
end

hook.Add("EntityTakeDamage", "drug_cigarette_preventdamage", function(ply, dmg)
	local att = dmg:GetAttacker()
	if att:IsPlayer() and att:GetDrugVar("drug_meth_high_end") > CurTime() then
		dmg:ScaleDamage(1.25)
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
	self:EmitSound("physics/surfaces/sand_impact_bullet1.wav")
	self:Remove()
end