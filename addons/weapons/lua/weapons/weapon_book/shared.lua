if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	language.Add("page_ammo", "Seiten")
end

game.AddAmmoType({name = "page", dmgtype = DMG_GENERIC})

if CLIENT then
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
end

SWEP.Base = "weapon_basekit"
SWEP.PrintName = "Buch der Transparenz"
SWEP.Purpose = "Ein unheiliges Buch aus den tiefen eines Dschungeltempels.\nDeaktiviere hiermit deine Kollision für eine begrenzte Zeit."
SWEP.Category = "Legendäre Waffen"
SWEP.Author = "Modern Gaming"
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = Model("models/weapons/w_grenade.mdl")
SWEP.ShowWorldModel = false
SWEP.ViewModelFOV = 57
SWEP.HoldType = "slam"

SWEP.Primary.Ammo = "page"
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Delay = 0.5
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModelBoneMods = {
	["v_weapon.Flashbang_Parent"] = {scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger0"] = {scale = Vector(1, 1, 1), pos = Vector(-1.297, 0.185, -0.926), angle = Angle(-10, 0, 0)},
	["ValveBiped.Bip01_R_Finger01"] = {scale = Vector(1, 1, 1), pos = Vector(0.185, 0, 0.4), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger02"] = {scale = Vector(1, 1, 1), pos = Vector(0.5, 0, 0.4), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger1"] = {scale = Vector(1, 1, 1), pos = Vector(1.296, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger11"] = {scale = Vector(1, 1, 1), pos = Vector(0.555, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger2"] = {scale = Vector(1, 1, 1), pos = Vector(2.036, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger3"] = {scale = Vector(1, 1, 1), pos = Vector(2.407, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger4"] = {scale = Vector(1, 1, 1), pos = Vector(0.925, -0.186, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_L_Clavicle"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, -1000), angle = Angle(0, 0, 0)},
}

SWEP.VElements = {
	["w_book"] = {type = "Model", model = "models/props_lab/binderblue.mdl", bone = "v_weapon.pull_ring", rel = "", pos = Vector(1.5, -3, 4), angle = Angle(-175, 125, -15), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["w_book"] = {type = "Model", model = "models/props_lab/binderblue.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 4.5, -4), angle = Angle(0, 90, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Booked")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	BaseClass.Initialize(self)
end

function SWEP:Deploy()
	if !IsValid(self.Owner) then return end

	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 0.8)
	self:SetNextSecondaryFire(CurTime() + 0.8)

	self:ChangeCollision(false)

	return true
end

function SWEP:ChangeCollision(enabled)
	self:SetBooked(enabled)

	if SERVER then
		local ply = self:GetOwner()
		if !IsValid(ply) then return end

		if !enabled then
			if ply.Booked and !ply.frozen then
				ply:SetNotSolid(false)
				ply:SetMaterial("")
				ply.Booked = nil
				self:AmmoRefill(false)
				ply:ChatPrint("Deine Kollision ist nun wieder aktiviert.")
				ply:EmitSound("ambient/materials/wood_creak4.wav")
				local edata = EffectData()
				edata:SetOrigin(ply:EyePos() - Vector(0, 0, 16))
				util.Effect("book_switch", edata, true, true)
			end
		else
			if !ply.Booked and !ply.frozen then
				ply:SetNotSolid(true)
				ply:SetMaterial("models/wireframe")
				ply.Booked = true
				self:AmmoRefill(true)
				ply:ChatPrint("Deine Kollision ist nun deaktiviert.")
				ply:EmitSound("ambient/materials/wood_creak4.wav")
				local edata = EffectData()
				edata:SetOrigin(ply:EyePos() - Vector(0, 0, 16))
				util.Effect("book_switch", edata, true, true)
			end
		end
	end
end

function SWEP:AmmoRefill(deplete)
	local ply = self:GetOwner()
	if !IsValid(ply) then return end
	local timername1 = "BookAmmoRefill_"..self:EntIndex()
	local timername2 = "BookAmmoDeplete_"..self:EntIndex()
	if !deplete then
		timer.Remove(timername2)
		if timer.Exists(timername1) then return end
		local wep = ply:GetWeapon("weapon_book")

		timer.Create(timername1, 0.4, 0, function()
			if !IsValid(wep) or !wep.Primary or !wep.Primary.ClipSize or wep:Clip1() >= wep.Primary.ClipSize then timer.Remove(timername1) return end
			wep:SetClip1(wep:Clip1() + 1)
			if wep:Clip1() >= wep.Primary.ClipSize then
				timer.Remove(timername1)
			end
		end)
	else
		timer.Remove(timername1)
		if timer.Exists(timername2) then return end
		local wep = ply:GetWeapon("weapon_book")

		timer.Create(timername2, 0.1, 0, function()
			if !IsValid(ply) then timer.Remove(timername2) return end
			if !IsValid(wep) or !wep.Primary or !wep.Primary.ClipSize or wep:Clip1() <= 0 then timer.Remove(timername2) return end
			wep:SetClip1(wep:Clip1() - 1)
			if wep:Clip1() <= 0 then
				timer.Remove(timername2)
				self:ChangeCollision(false)
			end
		end)
	end
end

function SWEP:Holster()
	self:ChangeCollision(false)
	return true
end

function SWEP:OnRemove()
	self:ChangeCollision(false)
end

function SWEP:PreDrop()
	self:ChangeCollision(false)
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		return false
	end
	return true
end

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) or self.Owner.frozen or !self:CanPrimaryAttack() or self:GetNextPrimaryFire() > CurTime() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if !SERVER then return end
	if self.Owner.Booked then
		self:ChangeCollision(false)
	elseif self.Owner:IsSolid() and !self.Owner.Booked then
		if self:Clip1() < self.Primary.ClipSize / 5 then return end
		self:ChangeCollision(true)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

if CLIENT then
	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {}
		self.AmmoDisplay.Draw = true
		self.AmmoDisplay.PrimaryClip = self:Clip1()
		return self.AmmoDisplay
	end

	function SWEP:GetViewModelPosition(pos, ang)
		local vm = IsValid(self.Owner) and self.Owner:GetViewModel()
		if IsValid(vm) then
			pos = pos + vm:GetUp() * -1
		end
		ang:RotateAroundAxis(ang:Up(), 5)
		ang:RotateAroundAxis(ang:Forward(), 1)
		ang:RotateAroundAxis(ang:Right(), -5)
		return pos, ang
	end

	function SWEP:PreDrawViewModel(vm, wep, ply)
		vm:SetMaterial("models/effects/vol_light001")

		if self:GetBooked() then
			local hands = ply:GetHands()
			if IsValid(hands) then
				hands:SetMaterial("models/wireframe")
			end
			local viewmodel = self.VElements["w_book"]
			if viewmodel then
				viewmodel.material = "models/wireframe"
			end
		end

		--BaseClass.PreDrawViewModel(self, vm, wep, ply)
	end
	
	function SWEP:PostDrawViewModel(vm, wep, ply)
		vm:SetMaterial("")
		local hands = ply:GetHands()
		if IsValid(hands) then
			hands:SetMaterial("")
		end
		local viewmodel = self.VElements["w_book"]
		if viewmodel then
			viewmodel.material = ""
		end

		--BaseClass.PostDrawViewModel(self, vm, wep, ply)
	end

	function SWEP:DrawWorldModel()
		local worldmodel = self.WElements["w_book"]
		if worldmodel then
			if self:GetBooked() then
				worldmodel.material = "models/wireframe"
			else
				worldmodel.material = ""
			end
		end

		BaseClass.DrawWorldModel(self)
	end
end