AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0))
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SetPlayer(ply)
	self:SetNW2Entity("Player", ply)
	if IsValid(ply) and ply:IsPlayer() then
		self.Model = ply:GetModel()
		util.PrecacheModel(self.Model)
		self:SetModel(self.Model)
		self:SetSkin(ply:GetSkin())
		self.GetPlayerColor = function()
			return ply:GetPlayerColor()
		end
		for i=0, ply:GetNumBodyGroups() - 1 do
			self:SetBodygroup(i, ply:GetBodygroup(i))
		end
	end
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0))
	self:NextThink(CurTime())
end

function ENT:SetBoard(ent)
	self:SetOwner(ent)
	self:SetNW2Entity("Board", ent)
	self:NextThink(CurTime())
end