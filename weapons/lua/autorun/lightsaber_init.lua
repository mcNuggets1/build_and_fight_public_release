if SERVER then
	AddCSLuaFile()
end

function LS_DrawHit(pos, dir)
	if !IsFirstTimePredicted() then return end
	local edata = EffectData()
	edata:SetOrigin(pos)
	edata:SetNormal(dir)
	util.Effect("StunstickImpact", edata, true, false)
	if SERVER then
		util.Decal("FadingScorch", pos + dir, pos - dir)
	end
end

if !SERVER then return end

hook.Add("AllowPlayerPickup", "lightsaber_prevent_use_pickup", function(ply, ent)
	if ent:GetClass() == "lightsaber" then return false end
end)

local function DoSliceSound(victim, inflictor)
	if !IsValid(inflictor) then return end
	if string.find(inflictor:GetClass(), "_lightsaber") then
		victim:EmitSound("lightsaber/saber_hit_laser"..math.random(1, 5)..".wav")
	end
end

hook.Add("EntityTakeDamage", "lightsaber_kill_snd", function(ent, dmg)
	if !IsValid(ent) or ent:IsNPC() or ent:IsPlayer() then return end
	if (ent:Health() > 0 and ent:Health() - dmg:GetDamage() <= 0) then
		DoSliceSound(ent, dmg:GetInflictor())
	end
end)

hook.Add("PlayerDeath", "lightsaber_kill_snd_ply", function(victim, inflictor, attacker)
	DoSliceSound(victim, inflictor)
end)

hook.Add("OnNPCKilled", "lightsaber_kill_snd_npc", function(victim, attacker, inflictor)
	DoSliceSound(victim, inflictor)
end)

local ls_damage = 3
function LS_DoDamage(tr, wep)
	local ent = tr.Entity
	if !IsValid(ent) then return end
	if ent:GetClass() == "func_breakable_surf" then ent:Fire("Shatter") return end
	if (ent:Health() <= 0 and ent:IsRagdoll()) then return end
	local dmg = ls_damage
	if wep.Swinging then
		dmg = dmg * 3
	end
	local dmginfo = DamageInfo()
	dmginfo:SetDamage(dmg * math.Rand(0.75, 1.25))
	dmginfo:SetDamageForce(tr.HitNormal * -13.37)
	dmginfo:SetInflictor(wep)
	if !IsValid(wep.Owner) then
		dmginfo:SetAttacker(wep)
	else
		dmginfo:SetAttacker(wep.Owner)
	end
	ent:TakeDamageInfo(dmginfo)
end