
include "shared.lua"

AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

ENT.throttle = 0
ENT.dir = 1
ENT.targetVel = 400

function ENT:Initialize()
	self:SetModel(self.model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
end


function ENT:PhysicsUpdate(ph)
	local tb = self:GetTable()
	local diff = tb.targetVel - ph:GetAngleVelocity().z*tb.dir
	ph:AddVelocity(self:GetUp()*math.Clamp(diff, 0, 1)*tb.throttle/200*tb.force)
end

