AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("InstrumentNetwork")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self:InitializeAfter()
end

function ENT:InitializeAfter()
end

local function HandleRollercoasterAnimation(vehicle, player)
	return player:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER)
end

function ENT:SetupChair(vecmdl, angmdl, vecvehicle, angvehicle)
	local ChairMDL = ents.Create("prop_physics_multiplayer")
	ChairMDL:SetModel(self.ChairModel)
	ChairMDL:SetParent(self)
	ChairMDL:SetPos(self:GetPos() + vecmdl)
	ChairMDL:SetAngles(angmdl)
	ChairMDL:DrawShadow(false)

	ChairMDL:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	ChairMDL:Spawn()
	ChairMDL:Activate()
	ChairMDL:SetOwner(self)
	
	local phys = ChairMDL:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	
	ChairMDL:SetKeyValue("minhealthdmg", "999999")

	self.ChairMDL = ChairMDL
	
	// Chair Vehicle
	local Chair = ents.Create("prop_vehicle_prisoner_pod")
	Chair:SetModel("models/nova/airboat_seat.mdl")
	Chair:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	Chair:SetPos(ChairMDL:GetPos() + vecvehicle)
	Chair:SetParent(ChairMDL)
	Chair:SetAngles(angvehicle)
	Chair:SetNotSolid(true)
	Chair:SetNoDraw(true)
	Chair:DrawShadow(false)
	Chair:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	Chair.HandleAnimation = HandleRollercoasterAnimation
	Chair:SetOwner(self)
	Chair:Spawn()
	Chair:Activate()

	self.Chair = Chair
	
	local phys = self.Chair:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
end

local function HookChair(ply, ent)
	local inst = ent:GetOwner()
	if IsValid(inst) and inst.Base == "gmt_instrument_base" then
		if !IsValid(inst:GetOwner()) then
			inst:AddOwner(ply)
			return true
		else
			if inst:GetOwner() == ply then
				return true
			end
		end

		return false
	end

	return true
end

hook.Add("CanPlayerEnterVehicle", "InstrumentChairHook", HookChair)
hook.Add("PlayerUse", "InstrumentChairModelHook", HookChair)

function ENT:Use(ply)
	if IsValid(self:GetOwner()) then return end

	self:AddOwner(ply)
end

local EyeAngle = Angle(25, 90, 0)
function ENT:AddOwner(ply)
	if IsValid(self:GetOwner()) then return end

	net.Start("InstrumentNetwork")
		net.WriteEntity(self)
		net.WriteUInt(INSTNET_USE, 2)
	net.Send(ply)

	ply.EntryPoint = ply:GetPos()
	ply.EntryAngles = ply:EyeAngles()

	self:SetOwner(ply)

	ply:EnterVehicle(self.Chair)
	ply:SetEyeAngles(EyeAngle)
end

function ENT:RemoveOwner()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end

	net.Start("InstrumentNetwork")
		net.WriteEntity(NULL)
		net.WriteUInt(INSTNET_USE, 2)
	net.Send(owner)
		
	owner:ExitVehicle(self.Chair)
	owner:SetPos(owner.EntryPoint)
	owner:SetEyeAngles(owner.EntryAngles)
end

function ENT:NetworkKey(key)
	if !IsValid(self:GetOwner()) then return end

	net.Start("InstrumentNetwork")
		net.WriteEntity(self)
		net.WriteUInt(INSTNET_HEAR, 2)
		net.WriteString(key)
	net.SendPAS(self:GetPos())
end

// Returns the approximate "fitted" number based on linear regression.
function math.Fit(val, valMin, valMax, outMin, outMax)
	return (val - valMin) * (outMax - outMin) / (valMax - valMin) + outMin
end	

net.Receive("InstrumentNetwork", function(length, client)
	local ent = Entity(net.ReadUInt(13))
	if !IsValid(ent) then return end

	local enum = net.ReadUInt(2)
	if enum == INSTNET_PLAY then
		if ent.Base != "gmt_instrument_base" || !IsValid(ent:GetOwner()) || client != ent:GetOwner() then return end

		local key = net.ReadString()
		ent:NetworkKey(key)

		local pos = string.sub(key, 2, 3)
		pos = math.Fit(tonumber(pos), 1, 36, -3.8, 4)

		local eff = EffectData()
			eff:SetOrigin(client:GetPos() + Vector(-15, pos * 10, -5))
		util.Effect("musicnotes", eff, true, true)
	end
end)

concommand.Add("instrument_leave", function(ply, cmd, args)
	if #args < 1 then return end

	local entid = args[1]
	local ent = ents.GetByIndex(entid)

	if !IsValid(ent) || ent.Base != "gmt_instrument_base" then return end
	if !IsValid(ent:GetOwner()) then return end

	if ply == ent:GetOwner() then
		ent:RemoveOwner()
	end
end)