SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Plant.\nSecondary Fire: Detonate."
SWEP.PrintName = "IED Detonator"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Weight	= 5
SWEP.HoldType = "fist"
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = Model("models/weapons/w_camphon2.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Round = "m9k_improvised_explosive"
SWEP.CanAim = false
SWEP.CanLower = false
SWEP.RunHoldType = "normal"
SWEP.RunSightsPos = Vector(2.4946, -1.5644, 1.699)
SWEP.RunSightsAng = Vector(-20.24, 12.1164, -12.959)
SWEP.BoxDropped = false

SWEP.RestrictToJob = true
SWEP.RestrictJob = TEAM_TERROR
SWEP.WrongJobText = "You can't use the IED-Detonator with your current job!"

SWEP.ViewModelBoneMods = {
	["v_weapon.knife_Parent"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 1.904), angle = Angle(0, 0, 0)},
	["v_weapon.Right_Middle02"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 35.375, 0)},
	["v_weapon.Right_Pinky03"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 31.504, 0)},
	["v_weapon.Right_Index02"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.875, 26.035, 0)},
	["v_weapon.Right_Index01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.912, 30.708, 0)},
	["v_weapon.Right_Ring01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6.368, 23.934, 0)},
	["v_weapon.Right_Index03"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 47.61, 0)},
	["v_weapon.Right_Pinky02"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27.075, 0)},
	["v_weapon.Right_Thumb03"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.138, -15.06, -13.447)},
	["v_weapon.Left_Arm"] = {scale = Vector(1, 1, 1), pos = Vector(-16.826, -30, 2.539), angle = Angle(0, 0, 0)},
	["v_weapon.Right_Middle01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.128, 0)},
	["v_weapon.Right_Ring03"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.68, 5.666, 0)},
	["v_weapon.Right_Pinky01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.523, 0)},
	["v_weapon.Right_Middle03"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -1.736, 0)},
	["v_weapon.Right_Thumb01"] = {scale = Vector(1, 1, 1), pos = Vector(-0.519, 0, 0), angle = Angle(-10.695, 2.921, 3.049)},
	["v_weapon.Right_Thumb02"] = {scale = Vector(1, 1, 1), pos = Vector(-0.009, 0, 0), angle = Angle(-5.969, 3.542, -26.505)},
	["v_weapon.Right_Ring02"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 35.75, 0)}
}
SWEP.VElements = {
	["phone"] = {type = "Model", model = "models/weapons/w_camphon2.mdl", bone = "v_weapon.knife_Parent", rel = "", pos = Vector(2.884, 1.353, 1.207), angle = Angle(13.812, 168.289, 83.724), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.Swing = {Sound("punchies/miss1.mp3"), Sound("punchies/miss2.mp3")}

function SWEP:PrimaryAttack()
	if !SERVER then return end
	if self.BoxDropped then return end
	self:SetNextPrimaryFire(CurTime() + 1)
	if self.RestrictToJob and DarkRP then
		if (self.Owner:Team() == self.RestrictJob) then
			self:DropBomb()
		else
			self.Owner:PrintMessage(HUD_PRINTTALK, self.WrongJobText)
		end
	else
		self:DropBomb()
	end
end

function SWEP:DropBomb()
	self.Owner:EmitSound(self.Swing[math.random(#self.Swing)])
	self.BoxDropped = true
	self.Owner:ViewPunch(Angle(-4, 0, 0))
	local aim = self.Owner:EyeAngles():Forward()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	local pos = self.Owner:GetShootPos() + side * -5 + up * -10
	local phonebomb = ents.Create(self.Primary.Round)
	if !IsValid(phonebomb) then return end
	phonebomb:SetAngles(aim:Angle() + Angle(90, 0, 0))
	phonebomb:SetPos(pos)
	phonebomb:SetNWEntity("Owner", self.Owner)
	phonebomb.Owner = self.Owner
	phonebomb:Spawn()
	local phys = phonebomb:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter(self.Owner:EyeAngles():Forward() * 1500)
	end
end

function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) then return end
	for _,v in ipairs(ents.FindByClass("m9k_improvised_explosive")) do
		if v:GetNWEntity("Owner") == self.Owner and !v.Boom then
			v.Boom = true
			self:SendWeaponAnim(ACT_VM_DRAW)
			if SERVER then
				timer.Simple(0.5, function()
					if IsValid(self) then
						MG_RemoveWeapon(self)
					end
				end)
			end
		end
	end
end