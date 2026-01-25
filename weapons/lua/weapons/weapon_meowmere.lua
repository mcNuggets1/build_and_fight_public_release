SWEP.Base = "weapon_basekit"
SWEP.PrintName = "Meowmere"
SWEP.Instructions = "Linkslick um Kristallkatzenfragmente zu schießen."
SWEP.Spawnable = true
SWEP.Category = "Legendäre Waffen"
SWEP.UseHands = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")
SWEP.HoldType = "melee2"
SWEP.Slot = 0
SWEP.SlotPos = 10

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.3
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_Spine"] = {scale = Vector(0.05, 0.015, 0.015), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

SWEP.VElements = {
	["meowmere"] = {type = "Model", model = "models/meowmere/meowmere.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 2, -2), angle = Angle(-45, -15, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["meowmere"] = {type = "Model", model = "models/meowmere/meowmere.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, -5, -2), angle = Angle(-50, 85, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1)
	BaseClass.Initialize(self)
end

local swing_sound = Sound("weapons/meowmere/swing.wav")
function SWEP:PrimaryAttack()
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(swing_sound)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if !SERVER then return end
	local aimvec = self.Owner:EyeAngles()
	local forward = aimvec:Forward()
	local right = aimvec:Right()
	local ent = ents.Create("meowcat")
	if !IsValid(ent) then return end
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos() + forward * 2 + right * 8)
	ent:SetAngles(aimvec)
	ent:Spawn()
	ent:Activate()
end

function SWEP:SecondaryAttack()
end