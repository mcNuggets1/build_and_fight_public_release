AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/ipha/mushroom_small.mdl")
ENT.MASS = 25
ENT.HEALTH = 50

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
	activator:SetHealth(activator:Health() / 1.05)
	if (activator:Health() <= 1) then
		activator:Kill()
		return false
	end
	if !activator.drug_mushroom_gravity then
		activator:SetGravity(0.25)
	end
	activator.drug_mushroom_gravity = true
	local uid = activator:UserID()
	hook.Add("Think", "drug_mushroom_resetgravity_"..uid, function()
		if !IsValid(activator) or !activator.drug_mushroom_gravity then hook.Remove("Think", "drug_mushroom_resetgravity_"..uid) return end
		if (activator.drug_mushroom_gravity and activator:GetDrugVar("drug_mushroom_high_end") < CurTime()) then
			activator.drug_mushroom_gravity = nil
			activator:SetGravity(1)
			hook.Remove("Think", "drug_mushroom_resetgravity_"..uid)
		end
	end)
end

hook.Add("PlayerSpawn", "drug_mushroom_resetgravity", function(ply)
	if ply.drug_mushroom_gravity then
		ply:SetGravity(1)
		ply.drug_mushroom_gravity = nil
	end
end)

hook.Add("PlayerDeath", "drug_mushroom_resetgravity", function(ply)
	if ply.drug_mushroom_gravity then
		ply:SetGravity(1)
		ply.drug_mushroom_gravity = nil
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
	self:EmitSound("physics/body/body_medium_break3.wav")
	local ed = EffectData()
	ed:SetOrigin(self:GetPos() + self:GetUp() * 2)
	util.Effect("drug_destroy_bloody", ed, true, true)
	self:Remove()
end