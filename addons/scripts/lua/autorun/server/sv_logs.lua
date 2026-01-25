timer.Simple(1, function()
	local reg = debug.getregistry()
	local Name = reg.Player.Name
	local SteamID = reg.Player.SteamID

	hook.Add("PlayerGiveSWEP", "MG_Log", function(ply, class)
		local name = Name(ply)
		local sid = SteamID(ply)

		local str = name.." ("..sid..") gave themself "..class

		ServerLog(str.."\n")
	end, HOOK_MONITOR_LOW or 2)

	hook.Add("PlayerSpawnSWEP", "MG_Log", function(ply, class)
		local name = Name(ply)
		local sid = SteamID(ply)

		local str = name.." ("..sid..") spawned weapon "..class

		ServerLog(str.."\n")
	end, HOOK_MONITOR_LOW or 2)

	hook.Add("PlayerSpawnedProp", "MG_Log", function(ply, model)
		local name = Name(ply)
		local sid = SteamID(ply)

		local str = name.." ("..sid..") spawned prop with model \""..model.."\""

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerSpawnedEffect", "MG_Log", function(ply, model)
		local name = Name(ply)
		local sid = SteamID(ply)

		local str = name.." ("..sid..") spawned effect \""..model.."\""

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerSpawnedRagdoll", "MG_Log", function(ply, model)
		local name = Name(ply)
		local sid = SteamID(ply)

		local str = name.." ("..sid..") spawned ragdoll \""..model.."\""

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerSpawnedSENT", "MG_Log", function(ply, ent)
		local name = Name(ply)
		local sid = SteamID(ply)
		local class = ent:GetClass()

		local str = name.." ("..sid..") spawned entity "..class

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerSpawnedVehicle", "MG_Log", function(ply, ent)
		local name = Name(ply)
		local sid = SteamID(ply)
		local class = ent:GetVehicleClass()

		local str = name.." ("..sid..") spawned vehicle "..class

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerSpawnedNPC", "MG_Log", function(ply, ent)
		local name = Name(ply)
		local sid = SteamID(ply)
		local class = ent:GetClass()

		local str = name.." ("..sid..") spawned NPC "..class

		ServerLog(str.."\n")
	end)

	hook.Add("CanTool", "MG_Log", function(ply, tr, class)
		local tb = ply:GetTable()

		if tb.LastToolgunLogInfo then
			if tb.LastToolgunLogInfo.usedTool == class and tb.LastToolgunLogInfo.nextAllowed > CurTime() then return end
		end

		tb.LastToolgunLogInfo = {
			usedTool = class,
			nextAllowed = CurTime() + 0.5,
		}

		local name = Name(ply)
		local sid = SteamID(ply)
		local model = tr.Entity:GetModel()

		local str = name.." ("..sid..") used tool "..class.." on \""..model.."\""

		ServerLog(str.."\n")
	end, HOOK_MONITOR_LOW or 2)

	hook.Add("OnNPCKilled", "MG_Log", function(npc, killer, weapon)
		local cls = npc:GetClass()
		local name = (killer:IsPlayer() and Name(killer)) or tostring(killer)
		local sid = (killer:IsPlayer() and SteamID(killer)) or tostring(killer)
		weapon = IsValid(weapon) and ((weapon:IsPlayer() and weapon:GetActiveWeapon():IsValid() and (weapon:GetActiveWeapon():GetPrintName() or weapon:GetActiveWeapon():GetClass())) or weapon:GetClass()) or "unknown"

		local str = cls.." was killed by "..name.." ("..sid..") with "..weapon

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerDeath", "MG_Log", function(ply, weapon, killer)
		local name = (killer:IsPlayer() and Name(killer)) or tostring(killer)
		weapon = IsValid(weapon) and ((weapon:IsPlayer() and weapon:GetActiveWeapon():IsValid() and (weapon:GetActiveWeapon():GetPrintName() or weapon:GetActiveWeapon():GetClass())) or weapon:GetClass()) or "unknown"

		if killer == ply then
			name = "Themself"
			weapon = "suicide trick"
		end

		local str = Name(ply).." ("..SteamID(ply)..") was killed by "..name.." with "..weapon

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerSilentDeath", "MG_Log", function(ply)
		local str = Name(ply).." ("..SteamID(ply)..") got killed silently"

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerDisconnected", "MG_Log", function(ply)
		local str = Name(ply).." ("..SteamID(ply)..") disconnected"

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerSpawn", "MG_Log", function(ply)
		local name = Name(ply)
		local sid = SteamID(ply)

		local str = name.." ("..sid..") spawned"

		ServerLog(str.."\n")
	end)

	hook.Add("PlayerAuthed", "MG_Log", function(ply, sid)
		local name = Name(ply)
		local sid = SteamID(ply)

		local str = name.." ("..sid..") is authed to the server"

		ServerLog(str.."\n")
	end)

	hook.Add("ShutDown", "MG_Log", function()
		ServerLog("Server successfully shut down\n")
	end)
end)