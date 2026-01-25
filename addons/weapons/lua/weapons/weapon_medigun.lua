if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	language.Add("Medicine_ammo", "Medizin")
	SWEP.BounceWeaponIcon = false
end

game.AddAmmoType({name = "Medicine", dmgtype = DMG_GENERIC})

SWEP.PrintName = "Medi Gun"
SWEP.Instructions = "Linksklick um andere Spieler zu heilen.\nRechtsklick um dich selber zu heilen."
SWEP.Author = "Modern Gaming"
SWEP.Purpose = "Heilt Ziel."
SWEP.Spawnable = true
SWEP.Base = "weapon_basekit"
SWEP.ViewModelFOV = 55
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = Model("models/weapons/w_irifle.mdl")
SWEP.Slot = 5
SWEP.SlotPos = 6
SWEP.HoldType = "ar2"
SWEP.Category = "Legendäre Waffen"
SWEP.HealAmount = 10
SWEP.HealOthersAmount = 15
SWEP.Primary.ClipSize = 60
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Ammo = "Medicine"
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.4
SWEP.Secondary.Delay = 0.6
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Sound = Sound("weapons/medigunshoot.wav")
SWEP.Secondary.Sound = Sound("weapons/medigunshoot.wav")
SWEP.IsGun = true

SWEP.VElements = {
	["v_medkit"] = {type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, 0, -3), angle = Angle(0, 180, 180), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["v_medkit"] = {type = "Model", model = "models/items/healthkit.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, 0, -3), angle = Angle(0, 180, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1)
	BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	local owner = self.Owner
	if !IsValid(owner) or !self:CanPrimaryAttack() then return end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:MuzzleFlash()
	owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo(1)
	owner:LagCompensation(true)
	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * 10000,
		filter = owner
	})
	owner:LagCompensation(false)
	if IsFirstTimePredicted() then
		local edata = EffectData()
		edata:SetOrigin(tr.HitPos)
		edata:SetStart(owner:GetShootPos())
		edata:SetAttachment(1)
		edata:SetEntity(self)
		util.Effect("heal_tracer", edata, true, false)
	end
	if tr.Hit then
		if IsFirstTimePredicted() then
			local edata = EffectData()
			edata:SetOrigin(tr.HitPos)
			util.Effect("medigun_heal", edata, true, false)
		end
		local ent = tr.Entity
		if IsValid(ent) and ent:IsPlayer() or ent:IsNPC() then
			ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + self.HealOthersAmount))
			ent:EmitSound(self.Primary.Sound, 60)
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	local owner = self.Owner
	if !IsValid(owner) or !self:CanPrimaryAttack() then return end
	self:ShootEffects()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(self.Secondary.Sound)
	self:TakePrimaryAmmo(2)
	if !SERVER then return end
	local pos = owner:Crouching() and Vector(0, 0, 28) or Vector(0, 0, 40)
	local edata = EffectData()
	edata:SetOrigin(owner:GetPos() + pos)
	util.Effect("medigun_heal", edata, true, true)
	owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + self.HealAmount))
end