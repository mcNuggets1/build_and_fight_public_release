SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "MAC 10"
SWEP.CSMuzzleFlashes = false
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "pistol"
SWEP.RunHoldType = "normal"
SWEP.ViewModelFOV = 72
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_notmic_98bmac10.mdl"
SWEP.WorldModel = Model("models/weapons/w_notmic_98bmac10.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("weapons/UMac-10U/mac-1.wav")
SWEP.Primary.RPM = 1000
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.KickUp = 0.45
SWEP.Primary.KickHorizontal = 0.35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 17
SWEP.Primary.Spread = 0.034
SWEP.Primary.IronAccuracy = 0.019
SWEP.DeployDelay = 0.9
SWEP.ReloadSpeed = 1.1
SWEP.SightsPos = Vector(-2.52, -1, 1.23)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0.839, 0, -1.119)
SWEP.RunSightsAng = Vector(-10.101, 27.2, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end

function SWEP:DrawWorldModel()
	local owner = self:GetOwner()

	local hand, offset, rotate

	if !IsValid(owner) then
		self:DrawModel()
		return
	end

	hand = owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if !hand then return end
	local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
	local m = owner:GetBoneMatrix(hand)
	if m then
		pos, ang = m:GetTranslation(), m:GetAngles()
	end

	pos = pos + (ang:Right() * 1 + ang:Forward() * 0 + ang:Up() * -1)

	ang:RotateAroundAxis(ang:Right(), 0)
	ang:RotateAroundAxis(ang:Forward(), 180)
	ang:RotateAroundAxis(ang:Up(), 0)

	self:SetRenderOrigin(pos)
	self:SetRenderAngles(ang)

	self:SetupBones()
	self:DrawModel()
end