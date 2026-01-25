if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	language.Add("melons_ammo", "Melonen")
end

game.AddAmmoType({name = "melons", dmgtype = DMG_CRUSH})

SWEP.Base = "weapon_basekit"
SWEP.PrintName = "Melonlauncher"
SWEP.Spawnable = true
SWEP.DrawCrosshair = false
SWEP.Purpose = "Jede getroffene Melone, ist eine glückliche Melone!"
SWEP.Author = "Modern Gaming"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")
SWEP.ViewModelFOV = 54
SWEP.HoldType = "rpg"
SWEP.Category = "Legendäre Waffen"
SWEP.Primary.Delay = 1.2
SWEP.Primary.Recoil = 3
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Ammo = "melons"
SWEP.Primary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

SWEP.VElements = {
	["melon"] = {type = "Model", model = "models/props_junk/watermelon01.mdl", bone = "base", rel = "", pos = Vector(-2, 0, 37), angle = Angle(0, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["melon"] = {type = "Model", model = "models/props_junk/watermelon01.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.8, -10, 19), angle = Angle(0, 90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1.4)
	BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) or !self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(-self.Primary.Recoil, 0, 0))
	self:EmitSound("weapons/grenade_launcher1.wav")
	self:TakePrimaryAmmo(1)
	if !SERVER then return end
	local ang = self.Owner:EyeAngles()
	local melon = ents.Create("prop_physics")
	if !IsValid(melon) then return end
	melon:SetModel("models/props_junk/watermelon01.mdl")
	melon:SetPos(self.Owner:GetShootPos() + ang:Right() * 13 + ang:Up() * 1)
	melon:SetAngles(ang)
	melon:SetPhysicsAttacker(self.Owner)
	melon:SetOwner(self.Owner)
	melon:Spawn()
	melon:Activate()
	local phys = melon:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(melon:GetForward() * 2200)
	end
	timer.Simple(10, function()
		if !IsValid(melon) then return end
		melon:TakeDamage(100, game.GetWorld(), game.GetWorld())
	end)
end

function SWEP:SecondaryAttack()
end