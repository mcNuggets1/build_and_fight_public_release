if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.Slot = 5
	SWEP.SlotPos = 50
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Einbruchswerkzeug"
SWEP.Spawnable = true
SWEP.Instructions = "Linksklick, um eine Tür aufzubrechen."

SWEP.UseHands = true
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.LockpickTime = 15

function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetDeploySpeed(2)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsLockpicking")
	self:NetworkVar("Float", 0, "LockpickStartTime")
	self:NetworkVar("Float", 1, "LockpickEndTime")
	self:NetworkVar("Float", 2, "NextSoundTime")
	self:NetworkVar("Int", 0, "TotalLockpicks")
	self:NetworkVar("Entity", 0, "LockpickEnt")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 2)
	if self:GetIsLockpicking() then return end
	self:GetOwner():LagCompensation(true)
	local trace = self:GetOwner():GetEyeTrace()
	self:GetOwner():LagCompensation(false)
	if (trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000) then return end
	if IsValid(trace.Entity) then
		local ent = trace.Entity
		local class = ent:GetClass()
		if (class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating" or class == "func_movelinear" or class == "prop_dynamic" or ent.isFadingDoor) then
			self:SetHoldType("pistol")
			self:SetIsLockpicking(true)
			self:SetLockpickEnt(ent)
			self:SetLockpickStartTime(CurTime())
			self:SetLockpickEndTime(CurTime() + self.LockpickTime)
			self:SetTotalLockpicks(self:GetTotalLockpicks() + 1)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	self:SetIsLockpicking(false)
	self:SetLockpickEnt(nil)
	return true
end

function SWEP:Succeed()
	self:SetHoldType("normal")
	local ent = self:GetLockpickEnt()
	self:SetIsLockpicking(false)
	self:SetLockpickEnt(nil)
	if !IsValid(ent) then return end
	if ent.isFadingDoor and ent.fadeActivate and !ent.fadeActive then
		ent:fadeActivate()
		if IsFirstTimePredicted() then
			timer.Simple(5, function()
				if IsValid(ent) and ent.fadeActive then
					ent:fadeDeactivate()
				end
			end)
		end
	elseif ent.Fire then
		ent:Fire("open", "", 0.6)
		ent:Fire("setanimation", "open", 0.6)
	end
end

function SWEP:Fail()
	self:SetIsLockpicking(false)
	self:SetHoldType("normal")
	self:SetLockpickEnt(NULL)
end

function SWEP:Think()
	if !self:GetIsLockpicking() or self:GetLockpickEndTime() == 0 then return end
	if CurTime() >= self:GetNextSoundTime() then
		self:SetNextSoundTime(CurTime() + 1)
		local snd = {1, 3, 4}
		self:EmitSound("weapons/357/357_reload"..tostring(snd[math.Round(util.SharedRandom("LockpickSound"..CurTime(), 1, #snd))])..".wav", 50, 100)
	end
	if CLIENT then
		if self.NextDotsTime and CurTime() <= self.NextDotsTime then return end
		self.NextDotsTime = CurTime() + 0.5
		self.Dots = self.Dots or ""
		local len = string.len(self.Dots)
		local dots = {[0] = ".", [1] = "..", [2] = "...", [3] = ""}
		self.Dots = dots[len]
	end
	local trace = self:GetOwner():GetEyeTrace()
	if !IsValid(trace.Entity) or trace.Entity != self:GetLockpickEnt() or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
		self:Fail()
	elseif self:GetLockpickEndTime() <= CurTime() then
		self:Succeed()
	end
end

if CLIENT then
	function draw.DrawNonParsedSimpleText(text, font, x, y, color, xAlign, yAlign)
		return draw.SimpleText(text, font, x, y, color, xAlign, yAlign)
	end

	function SWEP:DrawHUD()
		if !self:GetIsLockpicking() or self:GetLockpickEndTime() == 0 then return end
		self.Dots = self.Dots or ""
		local w = ScrW()
		local h = ScrH()
		local x, y, width, height = w / 2 - w / 10, h / 2 - 60, w / 5, h / 15
		draw.RoundedBox(4, x, y, width, height, Color(10,10,10,120))
		local time = self:GetLockpickEndTime() - self:GetLockpickStartTime()
		local curtime = CurTime() - self:GetLockpickStartTime()
		local status = math.Clamp(curtime / time, 0, 1)
		local BarWidth = status * (width - 16)
		draw.RoundedBox(0, x + 8, y + 8, BarWidth, height - 16, Color(255 - (status * 255), 0 + (status * 255), 0, 255))
		draw.DrawNonParsedSimpleText("Breche Tür auf"..self.Dots, "TargetID", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
	end
end