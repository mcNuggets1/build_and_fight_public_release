AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl")
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
	activator:SetDSP(6)
	if activator:Health() >= activator:GetMaxHealth() then return end
	activator:SetHealth(math.min(activator:Health() + math.random(10, 15), activator:GetMaxHealth()))
	if activator.getDarkRPVar then
		local hunger = activator:getDarkRPVar("Energy")
		if hunger and hunger >= 30 then
			activator:setSelfDarkRPVar("Energy", hunger - 5)
		end
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
	self:EmitSound("physics/surfaces/sand_impact_bullet1.wav")
	self:Remove()
end