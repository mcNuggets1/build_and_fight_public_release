include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetTrigger(true)
	local obb=self:OBBMaxs()
	self.RotorWidth=self:BoundingRadius()
	self.RotorHeight=obb.z
end

function ENT:StartTouch(e)
	local tb = self:GetTable()
	tb.BaseClass.StartTouch(e)
	if tb.TouchFunc then
		tb.TouchFunc(e, e:GetPos())
	end
end

function ENT:Think()
	local tb = self:GetTable()
	for i=0,360, 45 do
		local trd={}
		trd.start=self:GetPos()
		trd.endpos=self:GetRight()*math.sin(i)*tb.RotorWidth+self:GetForward()*math.cos(i)*tb.RotorWidth+trd.start+self:GetUp()*tb.RotorHeight
		trd.mask=MASK_SOLID_BRUSHONLY
		local tr=util.TraceLine(trd)
		if tr.Hit and !tr.HitSky and tr.HitWorld and tb.TouchFunc then
			tb.TouchFunc(tr.Entity, tr.HitPos)
		end
	end
end