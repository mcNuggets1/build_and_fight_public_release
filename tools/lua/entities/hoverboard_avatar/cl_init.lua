include("shared.lua")

function ENT:Draw()
	if !IsValid(self:GetNW2Entity("Board")) or !IsValid(self:GetNW2Entity("Board"):GetDriver()) or !IsValid(self:GetNW2Entity("Player")) then return end
	local ply = self:GetNW2Entity("Player")
	self.GetPlayerColor = function()
		if IsValid(ply) and ply.GetPlayerColor then
			return ply:GetPlayerColor()
		else
			return Vector(1, 1, 1)
		end
	end
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end