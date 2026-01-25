AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:InitServer()
end

function SWEP:DeployServer()
end

function SWEP:HolsterServer()
end

local strip_weapon = GetConVar("mg_m9k_stripweapon")
function SWEP:CheckWeaponsAndAmmo()
	if strip_weapon:GetBool() and IsValid(self.Owner) then
		if (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0) then
			timer.Simple(0.1, function()
   				if !IsValid(self) then return end
				MG_RemoveWeapon(self)
			end)
		end
	end
end