-- Fix network hitches of prisoner pods

hook.Add("OnEntityCreated", "MG_PodOptimisation", function(ent)
	if ent:GetClass() == "prop_vehicle_prisoner_pod" then
		ent:AddEFlags(EFL_NO_THINK_FUNCTION)
	end
end)

hook.Add("PlayerEnteredVehicle", "MG_PodOptimisation", function(_, vehicle)
	if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
		vehicle:RemoveEFlags(EFL_NO_THINK_FUNCTION)
	end
end)

hook.Add("PlayerLeaveVehicle", "MG_PodOptimisation", function(_, vehicle)
	if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
		local name = "MG_PodOptimisation_"..vehicle:EntIndex()
		local GetInternalVariable = vehicle.GetInternalVariable

		hook.Add("Think", name, function()
			if vehicle:IsValid() then
				if GetInternalVariable(vehicle, "m_bEnterAnimOn") == true then
					hook.Remove("Think", name)
				elseif GetInternalVariable(vehicle, "m_bExitAnimOn") == false then
					vehicle:AddEFlags(EFL_NO_THINK_FUNCTION)

					hook.Remove("Think", name)
				end
			else
				hook.Remove("Think", name)
			end
		end)
	end
end)

timer.Simple(0, function()
	-- player.* function overrides

	local player_meta = FindMetaTable("Player")

	local AccountIDs = {}
	function player.GetByAccountID(ID)
		return AccountIDs[ID] or false
	end

	local UniqueIDs = {}
	function player.GetByUniqueID(ID)
		return UniqueIDs[ID] or false
	end

	local SteamIDs = {}
	function player.GetBySteamID(ID)
		return SteamIDs[ID] or false
	end

	local SteamID64s = {}
	function player.GetBySteamID64(ID) 
		return SteamID64s[ID] or false
	end

	local AccountID = player_meta.AccountID
	local SteamID64 = player_meta.SteamID64
	local UniqueID = player_meta.UniqueID
	local SteamID = player_meta.SteamID
	hook.Add("PlayerInitialSpawn", "MG_PlayerCache", function(ply)
		AccountIDs[AccountID(ply)] = ply
		UniqueIDs[UniqueID(ply)] = ply
		SteamIDs[SteamID(ply)] = ply 
		SteamID64s[SteamID64(ply)] = ply
	end)

	hook.Add("PlayerDisconnected", "MG_PlayerCache", function(ply)
		AccountIDs[AccountID(ply)] = nil
		UniqueIDs[UniqueID(ply)] = nil
		SteamIDs[SteamID(ply)] = nil
		SteamID64s[SteamID64(ply)] = nil
	end)

	if !DarkRP then return end

	-- Remove redundant command

	concommand.Remove("_sendAllDoorData")
end)