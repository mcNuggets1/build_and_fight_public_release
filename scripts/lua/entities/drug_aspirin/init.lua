AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/jaanus/aspbtl.mdl")
ENT.DOES_HIGH = false
ENT.HEALTH = 20

function ENT:DoHighEffect(activator, caller)
	if !activator:IsPlayer() then return end
	if activator.drug_aspirin_used then
		activator:Kill()
		return
	end
	local hp_to_add = 75
	activator:SetHealth(activator:Health() + hp_to_add)
	activator.drug_aspirin_used = true
	local time = 0
	local uid = "drug_aspirin_loosehealth_"..activator:UserID()
	timer.Create(uid, 0.75, hp_to_add, function()
		if IsValid(activator) and activator.drug_aspirin_used and activator:Alive() then
			time = time + 1
			if time >= hp_to_add then
				activator.drug_aspirin_used = nil
			end
			if activator:Health() > 1 then
				activator:SetHealth(activator:Health() - 1)
			else
				activator:Kill()
			end
		else
			activator.drug_aspirin_used = nil
			timer.Remove(uid)
		end
	end)
end

hook.Add("playerSetAFK", "drug_darkrp_override", function(ply, bool)
	if bool then
		ply.drug_aspirin_afk = true
		timer.Stop("drug_aspirin_loosehealth_"..ply:UserID())
	else
		timer.Start("drug_aspirin_loosehealth_"..ply:UserID())
	end
end)

hook.Add("PlayerSpawn", "drug_aspirin_resethealth", function(ply)
	if !ply.drug_aspirin_afk then
		ply.drug_aspirin_used = nil
		timer.Remove("drug_aspirin_loosehealth_"..ply:UserID())
	else
		ply.drug_aspirin_afk = nil
	end
end)

hook.Add("PlayerDeath", "drug_aspirin_resethealth", function(ply)
	ply.drug_aspirin_used = nil
	timer.Remove("drug_aspirin_loosehealth_"..ply:UserID())
end)

hook.Add("PlayerDisconnected", "drug_aspirin_resethealth", function(ply)
	timer.Remove("drug_aspirin_loosehealth_"..ply:UserID())
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
	self:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav")
	self:Remove()
end