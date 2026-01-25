if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Getasert!"
SWEP.Author = "Modern Gaming"
SWEP.Purpose = "Du bist getastert!"
SWEP.Spawnable = false
SWEP.DrawAmmo = false
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.Slot = 100
SWEP.SlotPos = 100
SWEP.HoldType = "normal"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DisallowDrop = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PreDrawViewModel(vm)
	return true
end

function SWEP:Deploy()
    return true
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end