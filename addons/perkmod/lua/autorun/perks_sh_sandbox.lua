if SERVER then
	local XP_Playing = 400

	local XP_SpawnProp = 25
	local XP_UseTool = 10

	local XP_KillPlayer = 450
	local XP_DestroyProp = 75

	hook.Add("PlayerSpawnedProp", "Perks_GainXP", function(ply, model)
		if ply.IsBuilder and ply:IsBuilder() then
			if (ply.Perks_PropSpawnDelay or 0) > CurTime() then return end
			ply.Perks_PropSpawnDelay = CurTime() + 1
			ply:AddXP(XP_SpawnProp)
		end
	end)

	hook.Add("CanTool", "Perks_GainXP", function(ply, tr, tool)
		if FPP and FPP.canTouchEnt and !FPP.canTouchEnt(tr.Entity, "Toolgun") then return end
		if ply.IsBuilder and ply:IsBuilder() then
			if (ply.Perks_ToolDelay or 0) > CurTime() then return end
			ply.Perks_ToolDelay = CurTime() + 1
			ply:AddXP(XP_UseTool)
		end
	end)

	hook.Add("PropBreak", "Perks_GainXP", function(ply, prop)
		if IsValid(ply) and IsValid(prop) and ply.IsFighter and ply:IsFighter() then
			if (ply.Perks_PropDestroyDelay or 0) > CurTime() then return end
			ply.Perks_PropDestroyDelay = CurTime() + 2.5
			ply:AddXP(XP_DestroyProp)
		end
	end)

	hook.Add("PlayerDeath", "Perks_GainXP", function(victim, inflictor, killer)
		if IsValid(killer) and killer:IsPlayer() and killer.IsFighter and killer:IsFighter() then
			if victim == killer then return end
			killer:AddXP(XP_KillPlayer)
		end
	end)

	timer.Create("Perks_TimeAward", 60, 0, function()
		for _,v in ipairs(player.GetAll()) do
			v:AddXP(XP_Playing)
		end
	end)
end

hook.Add("M9K_ShootBullet", "Perks_WeaponModify", function(self, Damage, Recoil, NumBullets, Cone)
	local ply = self.Owner
	if !IsValid(ply) then return end

	local perk = "Doppelläufig"
	if ply:HasPerk(perk) then
		local chance = util.SharedRandom("PerkMod_"..CurTime(), 0, 1)
		if chance <= ply:GetPerkPercentage(perk) and (ply.Perks_ShotBullet or 0) != CurTime() then
			ply.Perks_ShotBullet = CurTime()
			self:ShootBullet(Damage, Recoil, 1, Cone)
		end
	end
end) 

hook.Add("M9K_SpeedMultiplier", "Perks_WeaponModify", function(self, speed)
	local ply = self.Owner
	if !IsValid(ply) then return end

	local perk = "Spezialist"
	if ply:HasPerk(perk) then
		speed = speed - (ply:GetPerkPercentage(perk) * speed)
	end

	return speed
end)

hook.Add("M9K_DeployMultiplier", "Perks_WeaponModify", function(self, speed)
	local ply = self.Owner
	if !IsValid(ply) then return end

	local perk = "Fester Griff"
	if ply:HasPerk(perk) then
		speed = speed + (ply:GetPerkPercentage(perk) * speed)
	end

	return speed
end)

hook.Add("M9K_ReloadMultiplier", "Perks_WeaponModify", function(self, speed)
	local ply = self.Owner
	if !IsValid(ply) then return end

	local perk = "Fingerfertigkeit"
	if ply:HasPerk(perk) then
		speed = speed + (ply:GetPerkPercentage(perk) * speed)
	end

	return speed
end)

hook.Add("M9K_ShotgunReloadMultiplier", "Perks_WeaponModify", function(self, speed)
	local ply = self.Owner
	if !IsValid(ply) then return end

	local perk = "Fingerfertigkeit"
	if ply:HasPerk(perk) then
		speed = speed - (ply:GetPerkPercentage(perk) * speed)
	end

	return speed
end)

hook.Add("M9K_RecoilMultiplier", "Perks_WeaponModify", function(self, recoil)
	local ply = self.Owner
	if !IsValid(ply) then return end

	local perk = "Ruhige Hand"
	if ply:HasPerk(perk) then
		recoil = recoil - (ply:GetPerkPercentage(perk) * recoil)
	end

	return recoil
end)

hook.Add("M9K_ConeMultiplier", "Perks_WeaponModify", function(self, cone)
	local ply = self.Owner
	if !IsValid(ply) then return end

	local perk = "Revolverheld"
	if ply:HasPerk(perk) and self.WeaponType == "revolver" then
		cone = cone - (ply:GetPerkPercentage(perk) * cone)
	end

	perk = "Adlerauge"
	if self.GetPredictedAiming and !self:GetPredictedAiming() then
		if ply:HasPerk(perk) then
			cone = cone - (ply:GetPerkPercentage(perk) * cone)
		end
	end

	perk = "Scharfschütze"
	if self.GetPredictedAiming and self:GetPredictedAiming() then
		if ply:HasPerk(perk) then
			cone = cone - (ply:GetPerkPercentage(perk) * cone)
		end
	end

	return cone
end)

if SERVER then
	hook.Add("PlayerSpawn", "Perks_SetupPerks", function(ply)
		timer.Simple(0, function()
			if IsValid(ply) and ply:Alive() then
				local perk = "Juggernaut"
				if ply:HasPerk(perk) and ply:Health() == ply:GetMaxHealth() then
					local perk = ply:GetPerkPercentage(perk)
					ply:SetHealth(math.floor(ply:Health() * (1 + perk)))
					ply:SetMaxHealth(math.floor(ply:GetMaxHealth() * (1 + perk)))
				end
				perk = "Blitzartig"
				if ply:HasPerk(perk) then
					local perk = ply:GetPerkPercentage(perk)
					ply:SetWalkSpeed(ply:GetWalkSpeed() * (1 + perk))
					ply:SetRunSpeed(ply:GetRunSpeed() * (1 + perk))
				end
			end
		end)
	end)

	local perk = "Vampir"
	hook.Add("PlayerDeath", "Perks_GiveLife", function(victim, inflictor, killer)
		if IsValid(killer) and killer:IsPlayer() and killer:Alive() and killer != victim and killer:HasPerk(perk) and killer:Health() < killer:GetMaxHealth() then
			killer:SetHealth(math.min(killer:Health() + killer:GetPerkPercentage(perk) * 100, killer:GetMaxHealth()))
		end
	end)

	hook.Add("EntityTakeDamage", "Perks_ScaleDamage", function(ply, dmginfo)
		local attacker = dmginfo:GetAttacker()
		if !IsValid(attacker) or !attacker:IsPlayer() then return end

		local is_player = ply:IsPlayer()
		local dmg = dmginfo:GetDamage()
		local is_bullet = dmginfo:IsBulletDamage()
		local hit, wep

		local perk = "Nahkämpfer"
		if attacker:HasPerk(perk) then
			wep = attacker:GetActiveWeapon()
			if wep:IsValid() and (dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH) or wep.WeaponType == "melee" or wep.WeaponType == "melee_dull" or wep.WeaponType == "melee_sharp") then
				dmg = (dmg * attacker:GetPerkPercentage(perk)) + dmg
			end
		end

		local perk = "Kurzer"
		if attacker:HasPerk(perk) then
			wep = wep or attacker:GetActiveWeapon()
			if wep:IsValid() and wep.WeaponType == "pistol" then
				dmg = dmg + (attacker:GetPerkPercentage(perk) * dmg)
			end
		end

		local perk = "Revolverheld"
		if attacker:HasPerk(perk) then
			wep = wep or attacker:GetActiveWeapon()
			if wep:IsValid() and wep.WeaponType == "revolver" then
				dmg = dmg + (attacker:GetPerkPercentage(perk) * dmg)
			end
		end

		perk = "Todeswut"
		if attacker:HasPerk(perk) and attacker:Alive() then
			if attacker:Health() < 20 then
				dmg = dmg + (attacker:GetPerkPercentage(perk) * dmg)
			end
		end

		perk = "Blutige Messe"
		if attacker:HasPerk(perk) then
			dmg = dmg + (attacker:GetPerkPercentage(perk) * dmg)
		end

		perk = "Resistenz"
		if is_player and ply:HasPerk(perk) then
			dmg = dmg - (ply:GetPerkPercentage(perk) * dmg)
		end

		perk = "Harte Knochen"
		if is_player and ply:HasPerk(perk) and is_bullet then
			hit = ply:LastHitGroup()
			if hit == HITGROUP_LEFTARM or hit == HITGROUP_RIGHTARM or hit == HITGROUP_LEFTLEG or hit == HITGROUP_RIGHTLEG then
				dmg = dmg - (ply:GetPerkPercentage(perk) * dmg)
			end
		end

		perk = "Stahlschädel"
		if is_player and ply:HasPerk(perk) and is_bullet then
			hit = hit or ply:LastHitGroup()
			if hit == HITGROUP_HEAD then
				dmg = dmg - (ply:GetPerkPercentage(perk) * dmg)
			end
		end

		perk = "Kritisch"
		if attacker:HasPerk(perk) then
			local chance = math.Rand(0, 1)
			if chance <= attacker:GetPerkPercentage(perk) then
				dmg = dmg * 1.5
			end
		end

		dmginfo:SetDamage(dmg)
	end)
end