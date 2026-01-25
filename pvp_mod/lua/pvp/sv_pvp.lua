include("sh_pvp.lua")

util.AddNetworkString("PVP_SendNotify")
util.AddNetworkString("PVP_SendChatMessage")

hook.Add("PlayerSay", "PVP_JoinBuilder", function(ply, text)
	if (PVP.BuilderCommands[string.lower(text)] == true) then
		ply:JoinBuilder()
		return ""
	end
end)

hook.Add("PlayerSay", "PVP_JoinFighter", function(ply, text)
	if (PVP.FighterCommands[string.lower(text)] == true) then
		ply:JoinFighter()
		return ""
	end
end)

hook.Add("PlayerInitialSpawn", "PVP_JoinServer", function(ply)
	timer.Simple(15, function()
		if IsValid(ply) then
			PVP.SendChatMessage(ply, Color(255, 50, 50), PVP.HelpMessage)
		end
	end)
end)

function PVP.SendNotify(ply, num, length, message, sendtoall)
	net.Start("PVP_SendNotify")
		net.WriteUInt(num, 4)
		net.WriteUInt(length, 8)
		net.WriteString(message)
	if sendtoall then
		net.Broadcast()
	else
		net.Send(ply)
	end
end

function PVP.SendChatMessage(ply, color, message, sendtoall)
	net.Start("PVP_SendChatMessage")
		net.WriteTable(color)
		net.WriteString(message)
	if sendtoall then
		net.Broadcast()
	else
		net.Send(ply)
	end
end

function PVP.SetLoadout(ply)
	ply:StripWeapons()
	if ply:IsBuilder() then
		for _,v in ipairs(PVP.BuilderLoadout) do
			ply:Give(v)
		end
		ply:SelectWeapon(PVP.DefaultBuilderWeapon)
	elseif ply:IsFighter() then
		for _,v in ipairs(PVP.FighterLoadout) do
			ply:Give(v)
		end
		ply:SelectWeapon(PVP.DefaultFighterWeapon)
		for k,v in pairs(PVP.FighterLoadoutAmmo) do
			ply:SetAmmo(v, k, true)
		end
	else
		ply:SetBuilder()
		PVP.SetLoadout(ply)
	end
	return true
end
hook.Add("PlayerLoadout", "PVP_SetLoadout", PVP.SetLoadout)

function PVP.RestrictWeapons(ply, wep, bool)
	if PVP.WeaponsAllowed then return end
	if PVP.AllowFighterWeapons and ply:IsFighter() then return end
	if (ply:IsBuilder() and (!PVP.GetAllowedWeapon(wep) or bool)) or (ply:IsFighter() and !ply:IsSuperAdmin()) then
		PVP.SendNotify(ply, 1, 4, "Du kannst diese Waffe nicht spawnen!")
		return false
	end
end

hook.Add("PlayerSpawnSWEP", "PVP_RestrictWeapons", function(ply, wep, bool)
	if PVP.RestrictWeapons(ply, wep, true) == false then
		return false
	end
end)

hook.Add("PlayerGiveSWEP", "PVP_RestrictWeapons", function(ply, wep, bool)
	if PVP.RestrictWeapons(ply, wep, false) == false then
		return false
	end
end)

function PVP.GetAllowedWeapon(wep)
	if !PVP.AllowedWeaponsBlacklist then
		if (PVP.AllowedWeapons[isstring(wep) and wep or wep:GetClass()] == true) then
			return true
		else
			return false
		end
	else
		if (PVP.AllowedWeapons[isstring(wep) and wep or wep:GetClass()] == true) then
			return false
		else
			return true
		end
	end
end

hook.Add("PlayerCanPickupWeapon", "PVP_RestrictWeapons", function(ply, wep)
	if PVP.WeaponsAllowed then return end
	if ply:IsBuilder() and !PVP.GetAllowedWeapon(wep) then
		return false
	end
end)

hook.Add("PlayerSpawnNPC", "PVP_RestrictNPCs", function(ply)
	if PVP.DisableNPCs and ply:IsFighter() then
		PVP.SendNotify(ply, 1, 5, "Du kannst als Fighter keine NPCs spawnen!")
		return false
	end
end)

hook.Add("PlayerSpawnProp", "PVP_RestrictProps", function(ply)
	if PVP.DisableProps and ply:IsFighter() then
		PVP.SendNotify(ply, 1, 5, "Du kannst als Fighter keine Props spawnen!")
		return false
	end
end)

hook.Add("PlayerSpawnSENT", "PVP_RestrictEntities", function(ply)
	if PVP.DisableEntities and ply:IsFighter() then
		PVP.SendNotify(ply, 1, 5, "Du kannst als Fighter keine Gegenstände spawnen!")
		return false
	end
end)

hook.Add("PlayerSpawnEffect", "PVP_RestrictEffects", function(ply)
	if PVP.DisableEffects and ply:IsFighter() then
		PVP.SendNotify(ply, 1, 5, "Du kannst als Fighter keine Effekte spawnen!")
		return false
	end
end)

hook.Add("PlayerSpawnRagdoll", "PVP_RestrictRagdolls", function(ply)
	if PVP.DisableRagdolls and ply:IsFighter() then
		PVP.SendNotify(ply, 1, 5, "Du kannst als Fighter keine Puppen spawnen!")
		return false
	end
end)

hook.Add("PlayerSpawnVehicle", "PVP_RestrictVehicles", function(ply)
	if PVP.DisableVehicles and ply:IsFighter() then
		PVP.SendNotify(ply, 1, 5, "Du kannst als Fighter keine Gefährte spawnen!")
		return false
	end
end)

hook.Add("CanProperty", "PVP_RestrictProperties", function(ply)
	if PVP.DisableProperties and ply:IsFighter() then
		PVP.SendNotify(ply, 1, 6, "Du musst Builder sein um Eigenschaften von Props verändern zu können!")
		return false
	end
end)

if PVP.EnablePSRewards then
	timer.Simple(0, function()
		if !PS then return end

		util.AddNetworkString("PVP_ScreenMessage")
		function PVP.GiveReward(ply, amt, msg)
			if ply.MG_AddMoney then
				ply:MG_AddMoney(amt)
			elseif PS then
				ply:PS_GivePoints(amt)
			end
			if msg then
				net.Start("PVP_ScreenMessage")
					net.WriteString(msg)
					net.WriteUInt(amt, 32)
				net.Send(ply)
			end
		end

		hook.Add("OnSpawnpointSpawned", "PS_RewardSpawnpoint", function(ply, spawnpoint)
			if ply.PS_KilledPlayers then
				local new_energy = PVP.PS_NewEnergy * ply.PS_KilledPlayers
				spawnpoint.RewardMoney = spawnpoint.RewardMoney and spawnpoint.RewardMoney + new_energy or new_energy
				PVP.GiveReward(ply, new_energy, "Neue Energie")
				ply.PS_KilledPlayers = nil
			end
		end)

		hook.Add("OnNormalSpawned", "PS_RewardSpawnpoint", function(ply)
			ply.PS_KilledPlayers = nil
		end)

		hook.Add("PlayerSpawn", "PS_ResetKillCount", function(ply)
			ply.PS_KillCount = nil
			ply.PS_Assists = nil
		end)

		hook.Add("PlayerDeath", "PS_RewardFighters", function(victim, inflictor, killer)
			local isvalid = IsValid(killer)
			killer.PS_KilledVictims = killer.PS_KilledVictims or {}
			local killed = killer.PS_KilledVictims[victim]
			for k in pairs(victim.PS_Assists or {}) do
				if !IsValid(k) then continue end
				if !isvalid or (isvalid and killer != k and killer != victim) then
					if isvalid and killed and killed > CurTime() then
						PVP.GiveReward(k, math.ceil(PVP.PS_KillReward_Assist / 5), "Langweilig mitgewirkt")
					else
						PVP.GiveReward(k, PVP.PS_KillReward_Assist, "Mitgewirkt")
					end
				end
			end
			if isvalid and killer:IsPlayer() and killer:IsFighter() and victim:IsFighter() and killer != victim then
				if (killed or 0) <= CurTime() then
					killer.PS_KillCount = killer.PS_KillCount and killer.PS_KillCount + 1 or 1
					killer.PS_KilledPlayers = killer.PS_KilledPlayers and killer.PS_KilledPlayers + 1 or 1
				end
				if (killed or 0) > CurTime() then
					PVP.GiveReward(killer, PVP.PS_KillReward_SameTarget, "Langweiler")
				elseif (killer.PS_KillCount or 0) > 1 then
					local kill_count = killer.PS_KillCount
					if kill_count <= 2 then
						PVP.GiveReward(killer, PVP.PS_KillReward_2Kills, "Doppeltötung")
					elseif kill_count == 3 then
						PVP.GiveReward(killer, PVP.PS_KillReward_3Kills, "Dreifachtötung")
					elseif kill_count == 4 then
						PVP.GiveReward(killer, PVP.PS_KillReward_4Kills, "Vierfachtötung")
					elseif kill_count == 5 then
						PVP.GiveReward(killer, PVP.PS_KillReward_5Kills, "Fünffachtötung")
					elseif kill_count == 6 then
						PVP.GiveReward(killer, PVP.PS_KillReward_6Kills, "Sechsfachtötung")
					elseif kill_count == 7 then
						PVP.GiveReward(killer, PVP.PS_KillReward_7Kills, "Siebenfachtötung")
					elseif kill_count == 8 then
						PVP.GiveReward(killer, PVP.PS_KillReward_8Kills, "Achtfachtötung")
					elseif kill_count == 9 then
						PVP.GiveReward(killer, PVP.PS_KillReward_9Kills, "Neunfachtötung")
					elseif kill_count == 10 then
						PVP.GiveReward(killer, PVP.PS_KillReward_10Kills, "Zehnfachtötung")
					elseif kill_count > 10 then
						PVP.GiveReward(killer, PVP.PS_KillReward_10KillsOrAbove, "Unaufhaltsam")
					end
				elseif (PVP.PS_KillReward_MeleeWeapons[inflictor:GetClass()] == true) or (killer:GetActiveWeapon():IsValid() and (killer:GetActiveWeapon():GetClass() == "weapon_crowbar" or killer:GetActiveWeapon():GetClass() == "weapon_stunstick")) then
					PVP.GiveReward(killer, PVP.PS_KillReward_Melee, "Nahkampf")
				elseif victim:LastHitGroup() == HITGROUP_HEAD then
					PVP.GiveReward(killer, PVP.PS_KillReward_Headshot, "Kopfschuss")
				elseif killer:Alive() and (killer:Health() <= killer:GetMaxHealth() * 0.1) then
					PVP.GiveReward(killer, PVP.PS_KillReward_NearDeath, "Nahe dem Tod")
				else
					PVP.GiveReward(killer, PVP.PS_KillReward, "Tötung erzielt")
				end
				killer.PS_KilledVictims[victim] = CurTime() + 15
				timer.Remove("PS_KillStreaks_"..killer:EntIndex())
				if killer.PS_KillCount then
					timer.Create("PS_KillStreaks_"..killer:EntIndex(), 10, 1, function()
						if IsValid(killer) then
							killer.PS_KillCount = nil
						end
					end)
				end
			end
			victim.PS_Assists = nil
		end)

		if PVP.PS_KillReward_AllowAssists then
			hook.Add("PlayerHurt", "PS_ComputeKillAssists", function(victim, attacker, hp, dmg)
				if IsValid(attacker) and attacker:IsPlayer() and attacker:IsFighter() and victim:IsFighter() and attacker != victim and dmg > 0 then
					victim.PS_Assists = victim.PS_Assists or {}
					victim.PS_Assists[attacker] = true
					timer.Remove("PS_Assists_"..victim:EntIndex())
					timer.Create("PS_Assists_"..victim:EntIndex(), 5, 1, function()
						if IsValid(victim) then
							victim.PS_Assists = nil
						end
					end)
				end
			end)
		end

		hook.Add("PlayerSpawnedProp", "PS_RewardBuilders", function(ply, model)
			if ply:IsBuilder() then
				if (ply.PS_PropSpawnDelay or 0) > CurTime() then return end
				ply.PS_PropSpawnDelay = CurTime() + 1
				if ply.MG_AddMoney then
					ply:MG_AddMoney(PVP.PS_SpawnReward)
				else
					ply:PS_GivePoints(PVP.PS_SpawnReward)
				end
			end
		end)

		hook.Add("CanTool", "PS_RewardBuilders", function(ply, tr, tool)
			if FPP and FPP.canTouchEnt and !FPP.canTouchEnt(tr.Entity, "Toolgun") then return end
			if ply:IsBuilder() then
				if (ply.PS_ToolDelay or 0) > CurTime() then return end
				ply.PS_ToolDelay = CurTime() + 2.5
				if ply.MG_AddMoney then
					ply:MG_AddMoney(PVP.PS_UseToolReward)
				else
					ply:PS_GivePoints(PVP.PS_UseToolReward)
				end
			end
		end)

		hook.Add("PropBreak", "PS_RewardBuilders", function(ply, prop)
			if IsValid(ply) and IsValid(prop) and ply:IsFighter() then
				if (ply.PS_PropDestroyDelay or 0) > CurTime() then return end
				ply.PS_PropDestroyDelay = CurTime() + 2.5
				if ply.MG_AddMoney then
					ply:MG_AddMoney(PVP.PS_BreakPropReward)
				else
					ply:PS_GivePoints(PVP.PS_BreakPropReward)
				end
			end
		end)
	end)
end

local mg_propdamage = CreateConVar("mg_propdamage", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
hook.Add("EntityTakeDamage", "PVP_RemoveDamage", function(ply, dmg)
	if !ply:IsPlayer() then return end
	if ply:IsBuilder() and PVP.BuilderInvincible then
		dmg:SetDamage(0)
		return true
	end
	if !mg_propdamage:GetBool() and PVP.DisableBuilderFighterDamage and ply:IsFighter() then
		local dmg_typ = dmg:GetDamageType()
		local infl = dmg:GetInflictor()
		if dmg_typ == DMG_CRUSH or dmg_typ == 5 then
			local has_owner = infl.CPPIGetOwner and IsValid(infl:CPPIGetOwner()) and infl:CPPIGetOwner():IsPlayer()
			if infl:IsWorld() or has_owner then
				dmg:SetDamage(0)
				return true
			end
		end
		local att = dmg:GetAttacker()
		if att:IsVehicle() then
			local driver = att:GetDriver()
			if IsValid(driver) and driver:IsPlayer() and driver:IsBuilder() then
				dmg:SetDamage(0)
				return true
			end
		end
		local isvalid_att = IsValid(att)
		local isvalid_infl = IsValid(infl)
		if isvalid_att or isvalid_infl then
			local att_has_owner = att.CPPIGetOwner and att:CPPIGetOwner()
			att_has_owner = IsValid(att_has_owner) and att_has_owner:IsPlayer() and att_has_owner:IsBuilder()
			local infl_has_owner = infl.CPPIGetOwner and infl:CPPIGetOwner()
			infl_has_owner = IsValid(infl_has_owner) and infl_has_owner:IsPlayer() and infl_has_owner:IsBuilder()
			local att_dmg_blocked = PVP.NoDamageOwnerEntities[isvalid_att and att:GetClass()]
			local infl_dmg_blocked = PVP.NoDamageOwnerEntities[isvalid_infl and infl:GetClass()]
			if att_dmg_blocked or infl_dmg_blocked then
				local att_has_alt_owner = isvalid_att and att:GetOwner()
				att_has_alt_owner = IsValid(att_has_alt_owner) and att_has_alt_owner:IsPlayer() and att_has_alt_owner:IsBuilder()
				local infl_has_alt_owner = isvalid_infl and infl:GetOwner()
				infl_has_alt_owner = IsValid(infl_has_alt_owner) and infl_has_alt_owner:IsPlayer() and infl_has_alt_owner:IsBuilder()
				if isvalid_att and att_has_alt_owner or isvalid_infl and infl_has_alt_owner then
					dmg:SetDamage(0)
					return true
				end
			end
			if isvalid_att and (att:IsPlayer() and att:IsBuilder() or att_has_owner) or isvalid_infl and (infl:IsPlayer() and infl:IsBuilder() or infl_has_owner) then
				dmg:SetDamage(0)
				return true
			end
		end
	end
end, HOOK_MONITOR_HIGH or -2)

if PVP.AllowDropCommand then
	hook.Add("PlayerSay", "PVP_DropWeapon", function(ply, text)
		if (PVP.DropWeaponCommands[string.lower(text)] == true) then
			local wep = ply:GetActiveWeapon()
			if (ply:Alive() and ply:IsFighter() and !ply.IsDroppingWeapon and wep:IsValid() and PVP.DisallowDrop[wep:GetClass()] != true) then
				ply.IsDroppingWeapon = true
				ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
				timer.Simple(0.9, function()
					if IsValid(ply) then
						ply.IsDroppingWeapon = nil
						if IsValid(wep) then
							if wep.PreDrop and isfunction(wep.PreDrop) then
								wep:PreDrop()
							end
							ply:DropWeapon(wep)
						end
					end
				end)
			end
			return ""
		end
	end)

	local weapons_to_remove = {}
	hook.Add("OnEntityCreated", "PVP_InitWeapon", function(ent)
		if ent:IsWeapon() or PVP.CleanMapEntities[ent:GetClass()] then
			weapons_to_remove[ent:EntIndex()] = ent
		end
	end)

	local nextcheck = 0
	hook.Add("Think", "PVP_TrackWeapons", function()
		local cur_time = CurTime()
		if nextcheck > cur_time then return end
		nextcheck = cur_time + 10
		for k,v in pairs(weapons_to_remove) do
			if IsValid(v) then
				local class = v:GetClass()
				local is_explosive = PVP.CleanMapEntities[class]
				if IsValid(v:GetOwner()) and !is_explosive then
					v.RemoveDelay = nil
					continue
				end
				v.RemoveDelay = v.RemoveDelay or (is_explosive and cur_time + 180 or cur_time + 120)
				if v.RemoveDelay <= cur_time then
					if is_explosive then
						v:TakeDamage(9999, game.GetWorld(), game.GetWorld())
					else
						v:Remove()
					end
				end
			else
				weapons_to_remove[k] = nil
			end
		end
	end)
end

if PVP.AllowFallDamage then
	hook.Add("GetFallDamage", "PVP_ComputeFallDamage", function(ply, vel)
		vel = vel - 580
		return vel * (100 / (1024 - 580))
	end)
end

local meta = FindMetaTable("Player")
function meta:JoinBuilder()
	if timer.Exists("PVP_SetBuilder_"..self:EntIndex()) then
		PVP.SendNotify(self, 1, 5, "Deine Klasse wird bereits zu Builder gewechselt!")
 		return
	end
	if self:IsFighter() then
		if hook.Run("CanPlayerSwitchTeam", self, 0) == false then return end
		PVP.SendNotify(self, 0, 5, "Deine Klasse wird in "..PVP.BuilderJoinDelay.." Sekunden zu Builder gesetzt!")
		timer.Create("PVP_SetBuilder_"..self:EntIndex(), PVP.BuilderJoinDelay, 1, function() 
			if IsValid(self) and self:IsFighter() then 
				PVP.SendNotify(self, 0, 4, "Du bist nun Builder!")
				self:BroadcastBuilder()
				self:SetBuilder()
				if self:Alive() then
					self:SetHealth(self:GetMaxHealth())
					PVP.SetLoadout(self)
				end
				self:SparkEffect()
			end
		end)
	else
		PVP.SendNotify(self, 1, 4, "Du bist bereits Builder!")
	end
	hook.Run("OnPlayerJoinedBuilder", self)
end

function meta:JoinFighter()
	if timer.Exists("PVP_SetBuilder_"..self:EntIndex()) then
		timer.Remove("PVP_SetBuilder_"..self:EntIndex())
		PVP.SendNotify(self, 1, 5, "Wechsel zu Builder abgebrochen!")
 		return
	end
	if self:IsBuilder() then
		if hook.Run("CanPlayerSwitchTeam", self, 1) == false then return end
		if self:Alive() then
			self:KillSilent()
		end
		PVP.SendNotify(self, 0, 4, "Du bist nun Fighter!")
		self:BroadcastFighter()
		self:SetFighter()
		self:SparkEffect()
	else
		PVP.SendNotify(self, 1, 4, "Du bist bereits Fighter!")
	end
	hook.Run("OnPlayerJoinedFighter", self)
end

function meta:SparkEffect()
	local edata = EffectData()
	edata:SetEntity(self)
	util.Effect("entity_remove", edata)
end

function meta:BroadcastBuilder()
	PVP.SendChatMessage(_, Color(255, 204, 51), self:Name()..PVP.BuilderMessage, true)
end

function meta:BroadcastFighter()
	PVP.SendChatMessage(_, Color(255, 204, 51), self:Name()..PVP.FighterMessage, true)
end

function meta:SetBuilder()
	self:SetTeam(100)
	hook.Run("OnPlayerSetBuilder", self)
end

function meta:SetFighter()
	self:SetTeam(200)
	hook.Run("OnPlayerSetFighter", self)
end

hook.Add("EntityTakeDamage", "PVP_BuilderSwitchDamage", function (ply, dmginfo)
	if ply:IsPlayer() and dmginfo:GetAttacker():IsPlayer() and timer.Exists("PVP_SetBuilder_"..ply:EntIndex()) then
		dmginfo:SetDamage(105)
	end
end)

hook.Add("DoPlayerDeath", "PVP_BuilderSwitchRespawn", function(ply, att, dmginfo)
	if timer.Exists("PVP_SetBuilder_"..ply:EntIndex()) then
		timer.Remove("PVP_SetBuilder_"..ply:EntIndex())
		if IsValid(ply) and ply:IsFighter() then 
			PVP.SendNotify(ply, 0, 4, "Du bist nun Builder!")
			ply:BroadcastBuilder()
			ply:SetBuilder()
			if ply:Alive() then
				ply:SetHealth(ply:GetMaxHealth())
				PVP.SetLoadout(ply)
			end
			ply:SparkEffect()
		end
	end	
end)

concommand.Add("builder", meta.JoinBuilder)
concommand.Add("fighter", meta.JoinFighter)