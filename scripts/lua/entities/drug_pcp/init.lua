AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/marioragdoll/Super Mario Galaxy/star/star.mdl")
ENT.HEALTH = 60
ENT.MASS = 30
ENT.MAXHEALTH = 150

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
	if activator:Health() >= self.MAXHEALTH then return end
	activator:SetHealth(math.min(activator:Health() + math.random(5, 10), self.MAXHEALTH))
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
	ed:SetOrigin(self:GetPos() + self:GetUp() * 10)
	ed:SetScale(1)
	util.Effect("drug_destroy_metalic", ed, true, true)
	self:EmitSound("physics/metal/metal_box_impact_bullet2.wav")
	self:Remove()
end