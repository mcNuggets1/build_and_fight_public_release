AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/katharsmodels/syringe_out/syringe_out.mdl")
ENT.HEALTH = 5

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
	activator:SetHealth(activator:Health() / 2)
	activator:SetMaxHealth(activator:GetMaxHealth() / 2)
	if (activator:Health() <= 1) then
		activator:Kill()
		return
	end
	local uid = "drug_heroin_resetinvincibilty_"..activator:UserID()
	hook.Add("Think", uid, function()
		if !IsValid(activator) or !activator:Alive() then hook.Remove("Think", uid) return end
		if (activator:GetDrugVar("drug_heroine_high_end") < CurTime()) then
			activator:Kill()
			hook.Remove("Think", uid)
		end
	end)
end

hook.Add("EntityTakeDamage", "drug_heroine_preventdamage", function(ply, dmg)
	if ply:IsPlayer() and ply:GetDrugVar("drug_heroine_high_end") > CurTime() then
		dmg:ScaleDamage(0.5)
	end
end)

hook.Add("OnPlayerChangedTeam", "drug_heroine_darkrp_override", function(ply, o, n)
	if DarkRP and ply:GetDrugVar("drug_heroine_high_end") >= CurTime() then
		DarkRP.notify(ply, 1, 4, "Du Schlingel krepierst schön am Heroin!")
		ply:Kill()
	end
end)

hook.Add("canGoAFK", "drug_heroine_darkrp_override", function(ply, bool)
	if (ply:GetDrugVar("drug_heroine_high_end") > CurTime()) then
		DarkRP.notify(ply, 1, 4, "Du Schlingel krepierst schön am Heroin!")
		return false
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
	ed:SetRadius(1)
	util.Effect("drug_destroy", ed, true, true)
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
	self:Remove()
end