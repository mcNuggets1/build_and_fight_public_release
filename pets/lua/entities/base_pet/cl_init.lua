include("shared.lua")

local hide_pet = CreateClientConVar("cl_pets_hide", 0, FCVAR_ARCHIVE)

local ply
function ENT:Draw()
	ply = ply or LocalPlayer()
	local is_owner = self:GetOwner() == ply

	if hide_pet:GetBool() and is_owner then return end
	
	self:DrawModel()
end

local ply
function ENT:DrawTranslucent()
	ply = ply or LocalPlayer()
	local is_owner = self:GetOwner() == ply

	if hide_pet:GetBool() and is_owner then return end
	
	self:DrawModel()
end