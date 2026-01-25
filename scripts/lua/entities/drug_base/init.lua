AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/props_c17/briefcase001a.mdl"
ENT.DOES_HIGH = true
ENT.HEALTH = 25

if SERVER then
	local Player = FindMetaTable("Entity")

	util.AddNetworkString("drug_updatevar")
	function Player:SetDrugVar(name, var)
		if (self[name] and self[name] == var) or (!self[name] and var == 0) then return end
		self[name] = var
		net.Start("drug_updatevar")
			net.WriteString(name)
			net.WriteFloat(var)
		net.Send(self)
		hook.Run("drug_varcall", self, name, var)
	end
end

function ENT:Initialize()
	self:SetModel(self.MODEL)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHealth(self.HEALTH)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		if self.MASS then
			phys:SetMass(self.MASS)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
 	self:TakePhysicsDamage(dmginfo)
end 

function MG_DoHighEffect(activator, class, deathpenalty, lastingeffect, transition_time)
	local curtime = CurTime()
	if (activator:GetDrugVar(class.."_high_end") > curtime and activator:GetDrugVar(class.."_high_end") - (transition_time or 5) < curtime) then
		activator:SetDrugVar(class.."_high_start", curtime - (activator:GetDrugVar(class.."_high_end") - curtime))
	elseif (activator:GetDrugVar(class.."_high_end") < curtime) then
		activator:SetDrugVar(class.."_high_start", curtime)
	end
	local ctime
	if (activator:GetDrugVar(class.."_high_end") < curtime) then
		ctime = curtime
	else
		ctime = activator:GetDrugVar(class.."_high_end") - lastingeffect / 3
	end
	activator:SetDrugVar(class.."_high_end", ctime + lastingeffect)
	if class == "drug_weed" or class == "drug_cigarette" then return end
	if (activator:GetDrugVar(class.."_high_end") > curtime + deathpenalty) then
		timer.Create("drug_killuser_"..activator:EntIndex(), 1, class == "drug_alcohol" and math.Rand(20, 40) or math.Rand(2, 10), function()
			if !IsValid(activator) or !activator:Alive() then return end
			activator:Kill()
		end)
	end
end

function ENT:Use(activator, caller)
	if !activator:IsPlayer() then return end
	if (self:DoHighEffect(activator, caller) == false) then return end
	if self.DOES_HIGH then
		MG_DoHighEffect(activator, self:GetClass(), self.DEATHPENALTY or 180, self.LASTINGEFFECT, self.TRANSITION_TIME)
	end
	self:PostHighEffect(activator, caller)
	self:Remove()
end

function ENT:DoHighEffect(activator, caller)
end

function ENT:PostHighEffect(activator, caller)
end

local function SoberUp(ply, notdead, didntdie)
	timer.Remove("drug_killuser_"..ply:EntIndex())
	local drugs = {"alcohol", "cigarette", "cocaine", "lsd", "meth", "mushroom", "pcp", "weed"}
	local ttime = {5, 3, 6, 4, 5, 6, 3, 5}
	if !didntdie then
		table.insert(ttime, 5)
		table.insert(drugs, "heroine")
	end
	for i=1, #drugs do
		local start = ply:GetDrugVar("drug_"..drugs[i].."_high_start")
		local stop = ply:GetDrugVar("drug_"..drugs[i].."_high_end")
		if start != 0 or stop != 0 then
			local tend = 0
			local curtime = CurTime()
			if (start + ttime[i] > curtime) then
				tend = (curtime - start) + curtime
			elseif !(stop - ttime[i] < curtime) then	
				tend = curtime + ttime[i]
			elseif (stop > curtime) then
				tend = stop
			end
			ply:SetDrugVar("drug_"..drugs[i].."_high_start", 0)
			ply:SetDrugVar("drug_"..drugs[i].."_high_end", tend)
		end
	end
	ply:SetDSP(1, false)
	if notdead then
		ply:EmitSound("vo/npc/male01/moan0"..math.random(4, 5)..".wav")
	end
end

hook.Add("PlayerDeath", "drug_sober_up_death", function(ply)
	SoberUp(ply, false, false)
end)

hook.Add("PlayerSpawn", "drug_sober_up_spawn", function(ply)
	SoberUp(ply, false, true)
end)

function ENT:Soberize(ply)
	SoberUp(ply, true, true)
end