if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 4
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.PrintName = "EMP"
SWEP.Author = "Modern Gaming"
SWEP.Instructions = "Linksklick um Fahrzeuge zu stoppen oder C4 zu entschärfen."
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.IsGun = true

if SERVER then
	util.AddNetworkString("EMP_NetworkDefuse")
end

function SWEP:Initialize()
	self:SetDeploySpeed(3)
end

if CLIENT then
	net.Receive("EMP_NetworkDefuse", function()
		local ent = net.ReadEntity()
		if !IsValid(ent) then return end
		timer.Remove("CountDown_"..ent:EntIndex())
	end)
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.2)
	self.Owner:LagCompensation(true)
	local mg = self.Owner:GetEyeTrace()
	self.Owner:LagCompensation(false)
	local ent = mg.Entity
	if !IsValid(ent) then return end
	local class = ent:GetClass()
	local defusable = class == "m9k_mad_c4" or class == "m9k_planted_c4"
	if (!ent:IsVehicle() and !defusable) or class == "prop_vehicle_prisoner_pod" then return end
	local pos = ent:GetPos()
	local distance = (self:GetPos() - pos):LengthSqr()
	if (distance > 100000) then return end
	if defusable then
		if !ent.Defused then
			if CLIENT then
				timer.Remove("CountDown_"..ent:EntIndex())
				ent.Defused = true
			end
		else
			return
		end
	end
	self:EmitSound("Weapon_StunStick.Activate")
	self:ShootEffects()
	self:SetNextPrimaryFire(CurTime() + 1.5)
	if SERVER then
		if defusable then
			if !ent.Defused then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "Entschärft!")
				ent.Think = function()
				end
				ent.Defused = true
				net.Start("EMP_NetworkDefuse")
					net.WriteEntity(ent)
				net.SendOmit(self.Owner)
				local effect = EffectData()
				effect:SetOrigin(pos)
				util.Effect("cball_explode", effect, true, true)
				sound.Play(zapsound, pos)
				SafeRemoveEntityDelayed(ent, 10)
				return
			end
		end
		self.Owner:PrintMessage(HUD_PRINTCENTER, "Fahrzeug wurde gestoppt!")
 		self:StopVehicle(ent)
		hook.Run("onStoppedVehicle", self.Owner, ent)
	end
end

function SWEP:StopVehicle(mg)
 	mg:Fire("TurnOff", "0")
	local tname = "MG_StartVehicle"..mg:EntIndex()
	if timer.Exists(tname) then timer.Remove(tname) end
	timer.Create(tname, 1, 8, function()
		if IsValid(mg) then
			if mg.VC_Health and mg.VC_Health <= 0 then return end
			if mg.VC_Fuel and mg.VC_Fuel <= 0 then return end
			mg:Fire("TurnOn", "0")
		end
	end)
end

function SWEP:SecondaryAttack()
end

local shoulddisable = {}
shoulddisable[5003] = true
shoulddisable[6001] = true
function SWEP:FireAnimationEvent(pos, ang, event, options)
	if shoulddisable[event] then return true end
end