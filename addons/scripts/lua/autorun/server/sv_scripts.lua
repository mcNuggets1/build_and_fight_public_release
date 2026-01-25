hook.Add("OnEntityCreated", "B&F_RemoveGibs", function(ent)
	if ent:GetClass() == "gib" then
		SafeRemoveEntityDelayed(ent, 30)
	end
end)

hook.Add("PlayerSpawn", "B&F_SetPlayerModel", function(ply)
	timer.Simple(0, function()
		if !IsValid(ply) then return end
		ply:SetModel("models/player/kleiner.mdl")
		ply:SetupHands()
	end)
end)

local money_mult = CreateConVar("mg_money_mult", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local meta = FindMetaTable("Player")
function meta:MG_AddMoney(amt)
	local mult = math.Clamp(money_mult:GetFloat(), 0, 2.5)
	if mult != 1 then
		amt = math.ceil(amt * mult)
	end
	self:PS_GivePoints(amt)
end

timer.Simple(0, function()
	local disallowed = {
		["moderator"] = true
	}

	local oldCleanup = cleanup.CC_AdminCleanup
	function cleanup.CC_AdminCleanup(ply, cmd, args)
		if IsValid(ply) and disallowed[ply:GetUserGroup()] then return end
		oldCleanup(ply, cmd, args)
	end
	concommand.Add("gmod_admin_cleanup", cleanup.CC_AdminCleanup, nil, "", {FCVAR_DONTRECORD})
end)

timer.Simple(0, function()
	local function DoNoCollide(ply)
		ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local tname = "SpawnProtection_NoCollide_"..ply:UserID()
		timer.Create(tname, 1, 0, function()
			if IsValid(ply) and ply:Alive() and ply:GetCollisionGroup() == COLLISION_GROUP_WEAPON then
				local found
				local pos = ply:GetPos()
				for _, f in ipairs(ents.FindInBox(pos + Vector(-16, -16, 0), pos + Vector(16, 16, 72))) do
					if f:IsPlayer() and f:Alive() and f != ply then
						found = true
						break
					end
				end
				if !found then
					ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
					timer.Remove(tname)
				end
			else
				if IsValid(ply) then
					ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				end
				timer.Remove(tname)
			end
		end)
	end

	function NoCollidePlayer(ply, pos, makesuitable, removeprops)
		local Ents = ents.FindInBox(pos + Vector(-16, -16, 0), pos + Vector(16, 16, 72))
		local Blocked = false
		for _, v in ipairs(Ents) do
			if v:IsPlayer() and v:Alive() then
				Blocked = true
				DoNoCollide(v)
			elseif removeprops then
				local class = v:GetClass()
				if class == "prop_physics" or class == "prop_physics_multiplayer" then
					v:Remove()
				end
			end
		end
		if Blocked then
			DoNoCollide(ply)
		end
		return Blocked
	end

	function GAMEMODE:IsSpawnpointSuitable(ply, spawnpointent, bMakeSuitable)
		local pos = spawnpointent:GetPos()
		local tm = ply:Team()
		if (tm == TEAM_SPECTATOR or tm == TEAM_UNASSIGNED) then return true end
		local Blocked = NoCollidePlayer(ply, pos, bMakeSuitable, true)
		if bMakeSuitable then return true end
		if Blocked then return false end
		return true
	end
end)

function MG_RemoveWeapon(wep, ply, noLastInv)
	if isstring(wep) then
		wep = ply:GetWeapon(wep)
		if !wep:IsValid() then return end
	end

	ply = ply or wep:GetOwner()
	if wep:IsValid() then
		if !noLastInv and IsValid(ply) and ply:GetActiveWeapon() == wep then
			ply:ConCommand("lastinv")
		end

		wep:Remove()
	end
end