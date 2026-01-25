AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = Model("models/drug_mod/alcohol_can.mdl")
ENT.HEALTH = 25

local ragdoll_chance = 0.96
local vomit_chance = 0.9

function MG_Vomit(activator)
	activator:EmitSound("mg_mp3/vomit.mp3")
	local edata = EffectData()
	edata:SetOrigin(activator:EyePos())
	edata:SetEntity(activator)
	util.Effect("drug_vomit", edata, true, true)
end

local commands = {"attack", "moveleft", "moveleft", "moveright", "moveright", "forward", "forward", "back", "back", "left", "right", "jump"}
function MG_AlcoholPoison(activator, max)
	local ncheck = CurTime() + 1
	local ncheck2 = CurTime() + 1
	local ncheck3 = CurTime() + 1
	local ncheck4 = CurTime() + 1
	local uid = "drug_alcohol_effects_"..activator:UserID()
	hook.Add("Think", uid, function()
		if !IsValid(activator) or !activator:Alive() then hook.Remove("Think", uid) return end
		local ends = activator:GetDrugVar("drug_alcohol_high_end")
		local cur_time = CurTime()
		local intensity = math.min((ends - cur_time) / (max * 1.25), 1)
		if intensity >= 0.2 and ncheck < cur_time then
			ncheck = cur_time + math.Rand(Lerp(intensity, 6, 2), Lerp(intensity, 12, 4)) 
			local cmd = commands[math.random(#commands)]
			activator:ConCommand("+"..cmd)
			timer.Simple(math.Rand(0.2, intensity + 0.2), function()
				if !IsValid(activator) then return end
				activator:ConCommand("-"..cmd)
			end)
		end
		if ncheck2 < cur_time then
			if intensity >= 0.1 and (ends - 1.5 > cur_time) then
				activator:ViewPunch(Angle(math.Rand(-intensity, intensity), math.Rand(-intensity, intensity), math.Rand(-intensity, intensity)) * 3)
				ncheck2 = cur_time + math.Rand(Lerp(intensity, 0.6, 0.08), Lerp(intensity, 1, 0.12))
			end
		end
		if RAGDOLL and ncheck3 < cur_time then
			ncheck3 = cur_time + 1 * math.Rand(0.75, 1.25)
			if intensity >= 0.6 and math.Rand(0, 1) >= ragdoll_chance and !activator.IsRagdolled then
				activator.KnockoutTimer = CurTime() + 5
				RAGDOLL.Ragdoll(activator, 2, activator:GetVelocity() * 1.3)
				DarkRP.log(activator:Name().." ("..activator:SteamID()..") fell asleep due to alcohol poisoning", Color(0, 255, 255))
				DarkRP.notify(activator, 1, 5, "Reguliere deinen Alkoholpegel!")
			end
		end
		if ncheck4 < cur_time then
			ncheck4 = cur_time + 1 * math.Rand(0.75, 1.25)
			if intensity >= 0.4 and math.Rand(0, 1) >= vomit_chance then
				MG_Vomit(activator)
			end
		end
		if (ends < cur_time) then
			hook.Remove("Think", uid)
		end
	end)
end

function ENT:DoHighEffect(activator, caller)
	if !activator:IsPlayer() then return end
	if DarkRP then
		activator:EmitSound("cookingmod/drinking.wav")
	end
	MG_AlcoholPoison(activator, self.DEATHPENALTY)
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
	ed:SetScale(0)
	util.Effect("drug_destroy_metalic", ed, true, true)
	self:EmitSound("physics/metal/soda_can_impact_hard"..math.random(1, 2)..".wav")
	self:Remove()
end