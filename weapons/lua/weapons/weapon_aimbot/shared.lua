if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	surface.CreateFont("Aimbot_Target", {font = "Arial", size = ScreenScale(10), weight = 400})
	SWEP.Slot = 2
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = true
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/ak47redline")
	SWEP.BounceWeaponIcon = false

	language.Add("aimbot_ammo", "Skill")
end

game.AddAmmoType({name = "aimbot", dmgtype = DMG_BULLET})

SWEP.Base = "weapon_basekit"
SWEP.PrintName = "Aimbot Gun"
SWEP.Spawnable = true
SWEP.Category = "Legendäre Waffen"
SWEP.Purpose = "Eine leichte Zielhilfe."
SWEP.Instructions = "Linksklick um zu schießen. Zielen ist nicht nötig!"
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/v_cloutak1.mdl"
SWEP.WorldModel = Model("models/weapons/w_irifle.mdl")
SWEP.ShowWorldModel = false
SWEP.ShowWorldModelNoOwner = true
SWEP.HoldType = "pistol"
SWEP.ViewModelFlip = true
SWEP.Primary.ClipSize = 250
SWEP.Primary.DefaultClip = 250
SWEP.Primary.Ammo = "aimbot"
SWEP.Primary.Delay = 0.04
SWEP.Primary.Automatic = true
SWEP.Primary.Sound = Sound("weapons/ak47/ak47redlinefire.wav")
SWEP.Primary.Damage = 1.75
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.005
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true
SWEP.NextUseTime = 0
SWEP.IsGun = true

SWEP.WeaponType = "assault"

SWEP.Aimbot = {}
SWEP.Aimbot.Target = NULL

SWEP.CSMuzzleFlashes = true

SWEP.WElements = {
	["ak47"] = {type = "Model", model = "models/weapons/w_cloutak1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.45, 0.929, 0.782), angle = Angle(-5.144, 0.823, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(0.5)
	BaseClass.Initialize(self)
end

function SWEP:GetHeadPos(ent)
	local attach = ent:GetAttachment(ent:LookupAttachment("eyes"))
	if attach then
		return attach.Pos
	else
		return ent:LocalToWorld(ent:OBBCenter())
	end
end

function SWEP:GetTargets()
	local tbl = {}
	for _,ent in ipairs(player.GetAll()) do
		if ent == self.Owner or !ent:Alive() or ent:GetNoDraw() or ent.IsBuilder and ent:IsBuilder() then continue end
		table.insert(tbl, ent)
	end
	return tbl
end

function SWEP:GetClosestTarget()
	local pos = self.Owner:GetPos()
	local ang = self.Owner:GetAimVector()
	local closest = {0, 0}
	for _,ent in ipairs(self:GetTargets()) do
		local diff = (ent:GetPos() - pos)
		diff:Normalize()
		diff = diff - ang
		diff = diff:Length()
		diff = math.abs(diff)
		if (diff < closest[2]) or (closest[1] == 0) then
			closest = {ent, diff}
		end
	end
	return closest[1]
end

function SWEP:Think()
	if !IsValid(self.Owner) then return end
	local ent = self:GetClosestTarget()
	self.Aimbot.Target = ent and IsEntity(ent) and ent or NULL
end


function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:SetNextPrimaryFire(CurTime())
		self:Reload()
		return false
	end
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime())
	self:SetNextSecondaryFire(CurTime())
	if !IsValid(self.Owner) then return end
	local aim = IsValid(self.Aimbot.Target) and self:GetHeadPos(self.Aimbot.Target) or false
	if CLIENT and aim then
		self.Owner:SetEyeAngles((aim - self.Owner:GetShootPos()):Angle())
	end
	if self.Owner:WaterLevel() > 2 or !self:CanPrimaryAttack() then return end
	if self.NextUseTime > CurTime() then return end
	self.NextUseTime = CurTime() + self.Primary.Delay
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:TakePrimaryAmmo(self.Primary.NumShots)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(self.Primary.Sound, 75, 100, 0.75)
	local bullet = {}
	bullet.Num = self.Primary.NumShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:EyeAngles():Forward()
	bullet.Spread = Vector(self.Primary.Cone, self.Primary.Cone, 0)
	bullet.Tracer = 1
	bullet.Force = 25
	bullet.Damage = self.Primary.Damage * math.Rand(0.75, 1.25)
	self.Owner:FireBullets(bullet)
end

function SWEP:FireAnimationEvent(pos, ang, event, options)
	if event == 20 then return true end	
	return BaseClass.FireAnimationEvent(self, pos, ang, event, options)
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime())
	self:SetNextSecondaryFire(CurTime())
	if !IsValid(self.Owner) then return end
	local aim = IsValid(self.Aimbot.Target) and self:GetHeadPos(self.Aimbot.Target) or false
	if CLIENT and aim then
		self.Owner:SetEyeAngles((aim - self.Owner:GetShootPos()):Angle())
	end
end

function SWEP:DrawRotatingCrosshair(x, y, time, length, gap)
	surface.DrawLine(x + (math.sin(math.rad(time)) * length), y + (math.cos(math.rad(time)) * length), x + (math.sin(math.rad(time)) * gap), y + (math.cos(math.rad(time)) * gap))
end

function SWEP:GetCoordiantes(ent)
	local min, max = ent:OBBMins(), ent:OBBMaxs()
	local corners = {Vector(min.x, min.y, min.z), Vector(min.x, min.y, max.z), Vector(min.x, max.y, min.z), Vector(min.x, max.y, max.z), Vector(max.x, min.y, min.z), Vector(max.x, min.y, max.z), Vector(max.x, max.y, min.z), Vector(max.x, max.y, max.z)}
	local minx, miny, maxx, maxy = ScrW() * 2, ScrH() * 2, 0, 0
	for _,corner in pairs(corners) do
		local screen = ent:LocalToWorld(corner):ToScreen()
		minx, miny = math.min(minx, screen.x), math.min(miny, screen.y)
		maxx, maxy = math.max(maxx, screen.x), math.max(maxy, screen.y)
	end
	return minx, miny, maxx, maxy
end

function SWEP:FixName(ent)
	return ent:Name()
end

function SWEP:DoDrawCrosshair()
	local x, y = ScrW(), ScrH()
	local w, h = x / 2, y / 2
	surface.SetDrawColor(Color(0, 0, 0, 235))
	surface.DrawRect(w - 1, h - 3, 3, 7)
	surface.DrawRect(w - 3, h - 1, 7, 3)
	surface.SetDrawColor(Color(0, 255, 10, 230))
	surface.DrawLine(w, h - 2, w, h + 2)
	surface.DrawLine(w - 2, h, w + 2, h)
	local time = CurTime() * -180		
	local scale = 10 * 0.02
	local gap = 40 * scale
	local length = gap + 20 * scale
	surface.SetDrawColor(0, 255, 0, 150)
	self:DrawRotatingCrosshair(w, h, time, length, gap)
	self:DrawRotatingCrosshair(w, h, time + 90, length, gap)
	self:DrawRotatingCrosshair(w, h, time + 180, length, gap)
	self:DrawRotatingCrosshair(w, h, time + 270, length, gap)
	if IsValid(self.Aimbot.Target) then
		surface.SetFont("Default")
		local text = "Ziel im Visier... ("..self:FixName(self.Aimbot.Target)..")"
		local size = surface.GetTextSize(text)
		draw.RoundedBox(4, 36, y - 135, size + 10, 20, Color(0, 0, 0, 100))
		draw.DrawText(text, "Default", 40, y - 132, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
		local x1, y1, x2, y2 = self:GetCoordiantes(self.Aimbot.Target)
		local edgesize = 4
		surface.SetDrawColor(Color(255, 0, 0, 200))
		surface.DrawLine(x1, y1, math.min(x1 + edgesize,x2), y1)
		surface.DrawLine(x1, y1, x1, math.min(y1 + edgesize, y2))
		surface.DrawLine(x2, y1,math.max(x2 - edgesize,x1), y1)
		surface.DrawLine(x2, y1, x2, math.min(y1 + edgesize, y2))
		surface.DrawLine(x1, y2, math.min(x1 + edgesize,x2), y2)
		surface.DrawLine(x1, y2, x1, math.max(y2 - edgesize, y1))
		surface.DrawLine(x2, y2, math.max(x2 - edgesize,x1), y2)
		surface.DrawLine(x2, y2, x2, math.max(y2 - edgesize, y1))
	end
	return true
end