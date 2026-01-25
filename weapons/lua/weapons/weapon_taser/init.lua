AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

TASER.ParalyzedTime = 4

local combinemodels = {
	["models/player/police.mdl"] = true,
	["models/player/police_fem.mdl"] = true
}

local females = {
	["models/player/alyx.mdl"] = true,
	["models/player/p2_chell.mdl"] = true,
	["models/player/mossman.mdl"] = true,
	["models/player/mossman_arctic.mdl"] = true
}
function TASER.PlayHurtSound(ply)
	local mdl = ply:GetModel()
	if combinemodels[mdl] or string.find(mdl, "combine") then
		return "npc/combine_soldier/pain"..math.random(1,3)..".wav"
	end
	if females[mdl] or string.find(mdl, "female") then
		return "vo/npc/female01/pain0"..math.random(1,9)..".wav"
	end
	return "vo/npc/male01/pain0"..math.random(1,9)..".wav"
end

local data = {}
function TASER.PlayerHullTrace(pos, ply, filter)
	data.start = pos
	data.endpos = pos
	data.filter = filter
	data.mask = MASK_SHOT
	return util.TraceEntity(data, ply)
end

local directions = {
	Vector(0, 0, 0), Vector(0, 0, 1),
	Vector(1, 0, 0), Vector(-1, 0, 0), Vector(0, 1, 0), Vector(0, -1, 0)
}

for deg = 45, 315, 90 do
	local r = math.rad(deg)
	table.insert(directions, Vector(math.Round(math.cos(r)), math.Round(math.sin(r)), 0))
end

local magn = 15
local iterations = 2
function TASER.PlayerSetPosNoBlock(ply, pos, filter)
	local tr
	local dirvec
	local m = magn
	local i = 1
	local its = 1
	repeat
		dirvec = directions[i] * m
		i = i + 1
		if i > #directions then
			its = its + 1
			i = 1
			m = m + magn
			if its > iterations then
				ply:SetPos(pos)
				return false
			end
		end
		tr = TASER.PlayerHullTrace(dirvec + pos, ply, filter)
	until tr.Hit == false
	ply:SetPos(pos + dirvec)
	return true
end

function TASER.SetupPlayerInvisibility(ply, bool)
	ply:SetNoDraw(bool)
	ply:SetNotSolid(bool)
	ply:SetCollisionGroup(bool and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_PLAYER)
	ply:SetMoveType(bool and MOVETYPE_NONE or MOVETYPE_WALK)
	ply:DrawShadow(!bool)
	ply:Freeze(bool)
end

local snd = Sound("taser/taser.wav")
local function CreateTaseSound(ent)
	ent.TaserSound = CreateSound(ent, snd)
	ent.TaserSound:PlayEx(1, 80)
end

local function RemoveTaseSound(ent)
	if ent.TaserSound  then
		ent.TaserSound:Stop()
		ent.TaserSound= nil
	end
end

function TASER.Ragdoll(ply, pushdir)
	ply:ExitVehicle()
	ply:Flashlight(false)
	ply:AllowFlashlight(false)
	ply:Extinguish()
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == "weapon_physcannon" then
		wep:Remove()
		timer.Simple(0.1, function()
			if IsValid(ply) and ply:Alive() then
				ply:Give("weapon_physcannon")
			end
		end)
	end
	ply:Give("weapon_tasered")
	ply:SelectWeapon("weapon_tasered")
	TASER.SetupPlayerInvisibility(ply, true)
	local plyphys = ply:GetPhysicsObject()
	local plyvel = Vector(0, 0, 0)
	if IsValid(plyphys) then
		plyvel = plyphys:GetVelocity()
	end
	local rag = ents.Create("prop_ragdoll")
	if !IsValid(rag) then return end
	rag:SetModel(ply:GetModel())
	rag:SetPos(ply:GetPos())
	rag:SetAngles(ply:GetAngles())
	rag:SetColor(ply:GetColor())
	rag:SetMaterial(ply:GetMaterial())
	rag:Spawn()
	rag:Activate()
	rag:SetOwner(ply)
	rag:SetDTEntity(0, ply)
	ply:SetParent(rag)
	ply.taseragdoll = rag
	rag.taseplayer = ply
	CreateTaseSound(rag)
	local phys = rag:GetPhysicsObject()
	if !IsValid(phys) then SafeRemoveEntity(rag) return end
	phys:SetInertia(Vector(1, 1, 1)) 
	for i=1,rag:GetPhysicsObjectCount() do
		if IsValid(rag:GetPhysicsObject(i-1)) then
			rag:GetPhysicsObject(i-1):SetMass(12.7)
		end
	end
	local num = rag:GetPhysicsObjectCount() - 1
	for i = 0, num do
		local bone = rag:GetPhysicsObjectNum(i)
		if IsValid(bone) then
			local bp, ba = ply:GetBonePosition(rag:TranslatePhysBoneToBone(i))
			if bp and ba then
				bone:SetPos(bp)
				bone:SetAngles(ba)
			end
			bone:SetVelocity(plyvel)
		end
	end
	plyvel = plyvel + pushdir * 30
	phys:SetVelocity(plyvel)
	local hname = "Ragdoll_RagdollMove_"..rag:EntIndex()
	hook.Add("Think", hname, function()
		if !IsValid(rag) then hook.Remove("Think", hname) return end
		if rag:GetCreationTime() + TASER.ParalyzedTime <= CurTime() then
			RemoveTaseSound(rag)
			hook.Remove("Think", hname)
			return
		end
		local phys = rag:GetPhysicsObjectNum(0)
		if phys:IsValid() then
			local vel = VectorRand() * 7.5 * 65 * FrameTime()
			for i = 1, rag:GetPhysicsObjectCount() do
				if IsValid(rag:GetPhysicsObject(i-1)) then
					rag:GetPhysicsObjectNum(i-1):AddVelocity(vel)
				end
			end
		end
	end)
	return rag
end

function TASER.Electrolute(ply, pushdir)
	if ply.taseimmune then return end
	local rag = TASER.Ragdoll(ply, pushdir)
	ply.istasered = true
	timer.Create("Taser_UnTase_"..ply:UserID(), TASER.ParalyzedTime, 1, function()
		if IsValid(ply) then
			TASER.UnTase(ply, true)
		end
	end)
	rag:EmitSound(TASER.PlayHurtSound(ply))
	local pos = rag:GetPos()
	local play = {1, 3, 4}
	timer.Simple(0, function()
		sound.Play("ambient/energy/spark"..play[math.random(1, #play)]..".wav", pos)
	end)
end

function TASER.UnRagdoll(ply)
	local rag = ply.taseragdoll
	if rag.AlreadyRemoved then return end
	rag.AlreadyRemoved = true
	TASER.SetupPlayerInvisibility(ply, false)
	ply:AllowFlashlight(true)
	if (ply:GetParent() == rag) then
		ply:SetParent()
		ply:StripWeapon("weapon_tasered")
		timer.Remove("Taser_UnTase_"..ply:UserID())
		TASER.PlayerSetPosNoBlock(ply, rag:GetPos(), {ply, rag})
		ply:SetVelocity(-ply:GetVelocity())
	end
	SafeRemoveEntity(rag)
end

function TASER.UnTase(ply, bool1, bool2)
	if IsValid(ply.taseragdoll) then
		TASER.UnRagdoll(ply)
	end
	ply.istasered = nil
	if bool1 then
		ply.taseimmune = true
		timer.Simple(1, function()
			if IsValid(ply) then
				ply.taseimmune = nil
			end
		end)
	end
end

hook.Add("EntityTakeDamage", "Taser_TakeDamage", function(ent, dmginfo)
	local ply = ent.taseplayer
	if IsValid(ply) and ply:IsPlayer() and ply:Alive() then
		local dmg = DamageInfo()
		dmg:SetAttacker(dmginfo:GetAttacker())
		dmg:SetInflictor(dmginfo:GetInflictor())
		dmg:SetDamageType(dmginfo:GetDamageType())
		if dmginfo:IsFallDamage() or dmginfo:IsDamageType(DMG_CRUSH) then
			dmg:SetDamageType(DMG_CRUSH)
			dmg:SetDamage(dmginfo:GetDamage() / 10)
		else
			dmg:SetDamage(dmginfo:GetDamage())
		end
		ply:TakeDamageInfo(dmg)
	end
end)

hook.Add("EntityRemoved", "Taser_EntityRemoved", function(ent)
	RemoveTaseSound(ent)
	if IsValid(ent.taseplayer) and !ent.AlreadyRemoved then
		TASER.UnRagdoll(ent.taseplayer)
	end
end)

hook.Add("PlayerSpawn", "Taser_PlayerSpawn", function(ply)
	TASER.UnTase(ply)
end)

timer.Simple(0, function()
	local Player = FindMetaTable("Player")
	local old_CreateRagdoll = Player.CreateRagdoll

	function Player:CreateRagdoll()
		if self.istasered then return end
		return old_CreateRagdoll(self)
	end
end)

hook.Add("DoPlayerDeath", "Taser_DoPlayerDeath", function(ply)
	timer.Remove("Taser_UnTase_"..ply:UserID())
	ply:Freeze(false)
	ply:SetParent()
	if IsValid(ply.taseragdoll) then
		ply.taseragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
end)

hook.Add("PlayerDisconnected", "Taser_PlayerDisconncted", function(ply)
	if IsValid(ply.taseragdoll) then
		timer.Remove("Taser_UnTase_"..ply:UserID())
		SafeRemoveEntity(ply.taseragdoll)
	end
end)

hook.Add("PlayerSpawnObject", "Taser_Restrict", function(ply)
	if ply.istasered then
		return false
	end
end)

hook.Add("PlayerUse", "Taser_Restrict", function(ply)
	if ply.istasered then
		return false
	end
end)

hook.Add("CanPlayerSuicide", "Taser_Restrict", function(ply)
	if ply.istasered then
		return false
	end
end)