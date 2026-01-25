SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Attack.\nSecondary Fire: Block."
SWEP.PrintName = "Damascus Sword"
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.Weight = 10
SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dmascus.mdl"
SWEP.WorldModel	= Model("models/weapons/w_damascus_sword.mdl")
SWEP.Primary.Sound = Sound("weapons/blades/woosh.mp3")
SWEP.Base = "mg_melee_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AimHoldType = "magic"
SWEP.RunHoldType = "melee2"
SWEP.SightsPos = Vector(-1.267, -15.895, -7.205)
SWEP.SightsAng = Vector(70, -27.234, 70)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-16, 0, 0)

SWEP.Primary.Damage = 28

SWEP.Primary.RPM = 225

SWEP.SwingSound1 = Sound("weapons/blades/woosh.mp3")
SWEP.HitSound1 = Sound("weapons/blades/hitwall.mp3")
SWEP.FleshSound1 = Sound("weapons/blades/slash.mp3")

SWEP.HitRange1 = 65

SWEP.AttackTime1 = 0.06

SWEP.TraceHull1 = {Vector(-8, -8, -6), Vector(8, 8, 6)}

SWEP.Throwable = false

SWEP.Bleed = true

SWEP.PhysicsForce1 = 150

SWEP.PrimaryAnimations = {"midslash1", "midslash2"}

SWEP.CanAttackWhileAiming = false
SWEP.CanAim = true
SWEP.Secondary.SightsFOV = 0

SWEP.WeaponType = "melee_sharp"

function SWEP:SecondaryAttack()
end

local blade_clash = Sound("weapons/blades/clash.mp3")
hook.Add("EntityTakeDamage", "M9K_SwordBlock", function(victim, info)
	if !victim:IsPlayer() or !victim:Alive() then return end 
	if !info:IsDamageType(DMG_SLASH) and !info:IsDamageType(DMG_CLUB) then return end
	local wep = victim:GetActiveWeapon()
	if wep:IsValid() and wep:GetClass() == "m9k_damascus" then
		if wep:GetAiming() then
			info:SetDamage(info:GetDamage() / 10)
			victim:EmitSound(blade_clash)
		end
	end
end)