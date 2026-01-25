util.AddNetworkString("hitnums_spawn")

local showalldamage = false
local breakablesonly = true
local mask_players = true
local mask_npcs = true
local mask_ragdolls = true
local mask_vehicles = true
local mask_props = true
local mask_world = false

local function IsWorld(ent)
	if ent:IsWorld() then return true end
	local class = ent:GetClass()
	return string.StartWith(class, "func_") or string.StartWith(class, "prop_door")
end

local function IsProp(ent)
	local class = ent:GetClass()
	return class == "prop_dynamic" or class == "prop_static" or class == "prop_physics" or class == "prop_physics_multiplayer"
end

local function SpawnIndicator(amount, dmgtype, dmgposition, dmgforce, critical, target, reciever)
	net.Start("hitnums_spawn", true)
		net.WriteFloat(amount)
		net.WriteUInt(dmgtype, 32)
		net.WriteBit(critical)
		net.WriteVector(dmgposition)
		net.WriteVector(dmgforce)
	if !reciever then
		if !target then
			net.Broadcast()
		else
			net.SendOmit(target)
		end
	else
		net.Send(reciever)
	end
end

hook.Add("EntityTakeDamage", "hitnums_damage", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local IsAttacker = attacker:IsPlayer()
	if (IsAttacker or showalldamage) and (!breakablesonly or target:Health() > 0) and (target:GetCollisionGroup() != COLLISION_GROUP_DEBRIS) and (attacker != target or showalldamage) then
		local IsPlayer = target:IsPlayer()
		local IsNPC	= target:IsNPC()
		if (!mask_players and IsPlayer) or (!mask_npcs and IsNPC) or (!mask_ragdolls and target:IsRagdoll()) or (!mask_vehicles and target:IsVehicle()) or (!mask_props and IsProp(target)) or (!mask_world and IsWorld(target)) then return end
		local amount = math.floor(dmginfo:GetDamage())
		amount = amount == 0 and math.Round(dmginfo:GetDamage(), 2) or amount
		local dmgtype = dmginfo:GetDamageType()
		local pos
		if dmginfo:IsBulletDamage() then
			pos = dmginfo:GetDamagePosition()
		elseif (IsAttacker or attacker:IsNPC()) and (dmgtype == DMG_CLUB or dmgtype == DMG_SLASH) then
			pos = util.TraceHull({start = attacker:GetShootPos(), endpos = attacker:GetShootPos() + (attacker:GetAimVector() * 100), filter = attacker, mins = Vector(-10, -10, -10), maxs = Vector(10, 10, 10), mask = MASK_SHOT_HULL,}).HitPos
		end
		if !pos then
			pos = target:LocalToWorld(target:OBBCenter())
		end
		local force
		if dmginfo:IsExplosionDamage() then
			force = dmginfo:GetDamageForce() / 3000
		else
			force = -dmginfo:GetDamageForce() / 1000
		end
		force.x = math.Clamp(force.x, -1, 1)
		force.y = math.Clamp(force.y, -1, 1)
		force.z = math.Clamp(force.z, -1, 1)
		local critical = (amount >= target:GetMaxHealth()) and (IsPlayer or IsNPC)
		if showalldamage then
			if IsPlayer then
				SpawnIndicator(amount, dmgtype, pos, force, critical, target, nil)
			else
				SpawnIndicator(amount, dmgtype, pos, force, critical, nil, nil)
			end
		else
			SpawnIndicator(amount, dmgtype, pos, force, critical, target, attacker)
		end
	end
end, HOOK_MONITOR_LOW or 2)