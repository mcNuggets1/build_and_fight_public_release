if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("Keypad_CrackKeypad_Sparks")
end

SWEP.PrintName = "Keypad Cracker"
SWEP.Slot = 1
SWEP.SlotPos = 100
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Instructions = "Linksklick um Keypads zu knacken."
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")
SWEP.Spawnable = true
SWEP.AnimPrefix = "python"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.KeyCrackTime = 8
SWEP.KeyCrackSound = Sound("buttons/blip2.wav")
SWEP.IdleStance = "slam"

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsCracking")
	self:NetworkVar("Float", 0, "StartCrack")
	self:NetworkVar("Float", 1, "EndCrack")
end

function SWEP:Initialize()
	self:SetHoldType(self.IdleStance)
end

function SWEP:Deploy()
	self:SetIsCracking(false)
	self:SetStartCrack(0)
	self:SetEndCrack(0)
	if CLIENT then
		self.LowerPercent = 1
	end
	return true
end

function SWEP:PrimaryAttack()
	if self:GetIsCracking() then return end
	local owner = self.Owner
	local tr = owner:GetEyeTrace()
	local ent = tr.Entity
	if IsValid(ent) and tr.HitPos:DistToSqr(owner:GetShootPos()) <= 2500 and ent.IsKeypad then
		local can_attach = hook.Run("canCrackKeypad", owner, ent, self)
		if can_attach == false then return end
		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetIsCracking(true)
		self:SetStartCrack(CurTime())
		local speed = self.KeyCrackTime
		speed = hook.Run("KeypadCrackTime", owner, self, speed) or speed
		self:SetEndCrack(CurTime() + speed)
		self:SetHoldType("pistol")
		hook.Run("onCrackKeypad", owner, self, ent)
		if SERVER then
			timer.Create("KeyCrackSounds: "..self:EntIndex(), 1, self.KeyCrackTime, function()
				if IsValid(self) and IsValid(owner) and self:GetIsCracking() then
					self:EmitSound(self.KeyCrackSound)
				end
			end)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Holster()
	self:SetIsCracking(false)
	self:SetStartCrack(0)
	self:SetEndCrack(0)
	if SERVER then
		timer.Remove("KeyCrackSounds: "..self:EntIndex())
	end
	return true
end

SWEP.OnRemove = SWEP.Holster

function SWEP:Succeed()
	self:SetIsCracking(false)
	self:SetStartCrack(0)
	self:SetEndCrack(0)
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	self:SetHoldType(self.IdleStance)
	if SERVER and IsValid(ent) and tr.HitPos:DistToSqr(self.Owner:GetShootPos()) <= 2500 and ent.IsKeypad then
		ent:Process(true)
		net.Start("Keypad_CrackKeypad_Sparks")
			net.WriteEntity(ent)
		net.Broadcast()
		hook.Run("onKeypadCracked", self.Owner, ent, self)
	end
	if SERVER then
		timer.Remove("KeyCrackSounds: "..self:EntIndex())
	end
end

function SWEP:Fail()
	self:SetIsCracking(false)
	self:SetStartCrack(0)
	self:SetEndCrack(0)
	self:SetHoldType(self.IdleStance)
	if SERVER then
		timer.Remove("KeyCrackSounds: "..self:EntIndex())
	end
end

function SWEP:Think()
	if self:GetIsCracking() and IsValid(self.Owner) then
		local tr = self.Owner:GetEyeTrace()
		local ent = tr.Entity
		if !IsValid(ent) or tr.HitPos:DistToSqr(self.Owner:GetShootPos()) > 2500 or !ent.IsKeypad then
			self:Fail()
		elseif self:GetEndCrack() <= CurTime() then
			self:Succeed()
		end
	else
		if IsValid(self.Owner) then
			self:SetHoldType(self.IdleStance)
		end
	end
	self:NextThink(CurTime())
	return true
end

if CLIENT then
	SWEP.BoxColor = Color(10, 10, 10, 100)

	local use_font = system.IsWindows() and "Tahoma" or "Verdana"
	surface.CreateFont("Keypad_CrackKeypad", {font = use_font, size = 18, weight = 600})

	local cracking = "Knacken..."
	function SWEP:DrawHUD()
		if self:GetIsCracking() then
			local frac = math.Clamp((CurTime() - self:GetStartCrack()) / (self:GetEndCrack() - self:GetStartCrack()), 0, 1)
			local w, h = ScrW(), ScrH()
			local x, y = (w / 2) - 150, (h / 2) - 25
			local w, h = 300, 50
			draw.RoundedBox(4, x, y, w, h, self.BoxColor)
			surface.SetDrawColor(Color(255 + (frac * -255), frac * 255, 40))			
			surface.DrawRect(x + 5, y + 5, frac * (w - 10), h - 10)
			surface.SetFont("Keypad_CrackKeypad")
			local fontw, fonth = surface.GetTextSize(cracking)
			local fontx, fonty = (x + (w / 2)) - (fontw / 2), (y + (h / 2)) - (fonth / 2)
			surface.SetTextPos(fontx + 1, fonty + 1)
			surface.SetTextColor(color_black)
			surface.DrawText(cracking)
			surface.SetTextPos(fontx, fonty)
			surface.SetTextColor(color_white)
			surface.DrawText(cracking)
		end
	end

	SWEP.DownAngle = Angle(-10, 0, 0)
	SWEP.LowerPercent = 1
	SWEP.SwayScale = 0

	function SWEP:GetViewModelPosition(pos, ang)
		if self:GetIsCracking() then
			local delta = RealFrameTime() * 3.5
			self.LowerPercent = math.Clamp(self.LowerPercent - delta, 0, 1)
		else
			local delta = RealFrameTime() * 5
			self.LowerPercent = math.Clamp(self.LowerPercent + delta, 0, 1)
		end
		ang:RotateAroundAxis(ang:Forward(), self.DownAngle.p * self.LowerPercent)
		ang:RotateAroundAxis(ang:Right(), self.DownAngle.p * self.LowerPercent)
		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	net.Receive("Keypad_CrackKeypad_Sparks", function()
		local ent = net.ReadEntity()
		if !IsValid(ent) then return end
		local vPoint = ent:GetPos()
		local effect = EffectData()
		effect:SetStart(vPoint)
		effect:SetOrigin(vPoint)
		effect:SetEntity(ent)
		effect:SetScale(2)
		util.Effect("cball_bounce", effect)
		ent:EmitSound("buttons/combine_button7.wav", 100, 100)
	end)
end