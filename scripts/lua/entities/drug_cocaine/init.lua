AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/cocn.mdl")
ENT.HEALTH = 15

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
	activator:SetHealth(activator:Health() / 1.1)
	if (activator:Health() <= 1) then
		activator:Kill()
		return false
	end
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
	ed:SetRadius(0)
	util.Effect("drug_destroy", ed, true, true)
	self:EmitSound("physics/concrete/concrete_impact_bullet1.wav")
	self:Remove()
end

local function AdjustCocainePlayerSpeed(ply, mv)
	if ply:GetDrugVar("drug_cocaine_high_end") > CurTime() then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 1.5)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 1.5)
	end
end

local cocaine_plys = {}
hook.Add("drug_varcall", "drug_cocaine_vars", function(ply, name, var)
	if name == "drug_cocaine_high_end" then
		if !var or var == 0 then
			for k in pairs(cocaine_plys) do
				if !k:IsValid() then
					cocaine_plys[k] = nil
				end
			end
			cocaine_plys[ply] = nil
			if table.IsEmpty(cocaine_plys) then
				hook.Remove("Move", "drug_cocaine_speed")
			end
		else
			for k in pairs(cocaine_plys) do
				if !k:IsValid() then
					cocaine_plys[k] = nil
				end
			end
			if table.IsEmpty(cocaine_plys) then
				hook.Add("Move", "drug_cocaine_speed", AdjustCocainePlayerSpeed)
			end
			cocaine_plys[ply] = true
		end
	end
end)