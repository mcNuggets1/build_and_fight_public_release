util.AddNetworkString("SpawnProtection_SendState")

local function SpawnProtection_NetworkState(ply, protected, starttime, length)
	net.Start("SpawnProtection_SendState")
		net.WriteBool(protected)
		net.WriteFloat(starttime, 32)
		net.WriteFloat(length, 16)
	net.Send(ply)
end

hook.Add("PlayerSpawn", "SpawnProtection_Apply", function(ply)
	if ply:IsFighter() and ply.SP_ShouldGodMode then
		local spawntime = 5
		if ply.SP_ExtraTime then
			ply.SP_ExtraTime = false
			spawntime = 8
		end
		if IsValid(ply.Spawnpoint) then
			spawntime = 1
		end
		local c = ply:GetColor()
		ply.SP_LastColor = c
		ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
		ply:SetColor(Color(c.r, c.g, c.b, 100))
		ply.SP_ShouldGodMode = false
		ply.SP_GodModeActive = true
		SpawnProtection_NetworkState(ply, true, CurTime(), spawntime)
		timer.Create("SpawnProtection_"..ply:EntIndex(), spawntime, 1, function()
			if !IsValid(ply) then return end
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor(Color(c.r, c.g, c.b, c.a))
			ply.SP_GodModeActive = false
			ply.SP_LastGodMode = CurTime()
			SpawnProtection_NetworkState(ply, false, CurTime(), 0)
		end)
	end
end)

local function RemoveSpawnProtection(ply)
	ply.SP_ShouldGodMode = true
	local index = ply:EntIndex()
	if timer.Exists("SpawnProtection_"..index) then
		timer.Remove("SpawnProtection_"..index)
		ply:SetRenderMode(RENDERMODE_NORMAL)
		ply:SetColor(ply.SP_LastColor or Color(255, 255, 255, 255))
		ply.SP_GodModeActive = false
		SpawnProtection_NetworkState(ply, false, CurTime(), 0)
	end
end

hook.Add("PlayerDeath", "SpawnProtection_Disable", function(ply)
	if (ply.SP_LastGodMode or 0) > CurTime() + 15 then
		ply.SP_ExtraTime = true
	end
	RemoveSpawnProtection(ply)
end)

hook.Add("PlayerSilentDeath", "SpawnProtection_Disable", function(ply)
	RemoveSpawnProtection(ply)
end)

hook.Add("EntityTakeDamage", "SpawnProtection_PreventDamage", function(target)
	if IsValid(target) and target.SP_GodModeActive then
		return true
	end
end)