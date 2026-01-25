TASER = {}

SWEP.Base = "weapon_basekit"
SWEP.PrintName = "Taser"
SWEP.Category = "Legendäre Waffen"
SWEP.Instructions = "Linksklick um einen Spieler zu tasern."
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

SWEP.Range = 300 * 300
SWEP.Charge = 100
SWEP.RechargeTime = 1.4
SWEP.DepletionTime = 0.4

DEFINE_BASECLASS("weapon_basekit")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Deplete")
	self:NetworkVar("Float", 0, "LastUse")
	self:NetworkVar("Float", 1, "Charge")
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self:SetHoldType(self.HoldType)
	self:SetCharge(100)
	if CLIENT then
		self.VElements["counter"].draw_func = function()
			self:DrawScreen(-27, -65, 65, 123)
		end
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
	return true
end

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	if self:GetCharge() < 100 then return end
	self:SetLastUse(CurTime())
	self:SetDeplete(true)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		self.Owner:EmitSound("npc/turret_floor/shoot1.wav", 100)
		self.Owner:LagCompensation(true)
		local tr = self.Owner:GetEyeTrace()
		self.Owner:LagCompensation(false)
		local ent = tr.Entity
		local disttosqr = self.Owner:GetShootPos():DistToSqr(tr.HitPos)
		if IsValid(ent) and ent:IsPlayer() and !IsValid(ent.taseragdoll) and ent != self.Owner and disttosqr < self.Range and hook.Run("canTasePlayer", self.Owner, self, ent) != false then
			if ent.IsBuilder and ent:IsBuilder() or ent.SP_GodModeActive or ent.SZ_Protected then return end
			local edata = EffectData()
			edata:SetOrigin(tr.HitPos)
			edata:SetStart(self.Owner:GetShootPos())
			edata:SetAttachment(1)
			edata:SetEntity(self)
			util.Effect("ToolTracer", edata, true, true)
			TASER.Electrolute(ent, (ent:GetPos() - self.Owner:GetPos()):GetNormal())
			hook.Run("onPlayerTasered", self.Owner, ent)
		end
	end
end

function SWEP:Think()
	if self:GetCharge() < 100 or self:GetDeplete() then
		local charge = self:GetDeplete() and 100 - ((CurTime() - self:GetLastUse()) / self.DepletionTime) * 100 or ((CurTime() - self:GetLastUse()) / self.RechargeTime) * 100
		self:SetCharge(math.Clamp(charge, 0, 100))
		if self:GetCharge() <= 0 and self:GetDeplete() then
			self:SetLastUse(CurTime())
			self:SetDeplete(false)
			self:SetCharge(0)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

local shoulddisable = {}
shoulddisable[5003] = true
shoulddisable[6001] = true
function SWEP:FireAnimationEvent(pos, ang, event, options)
	if shoulddisable[event] then return true end
end

hook.Add("PhysgunPickup", "Taser_Restrict", function(ply, ent)
	if ent:IsRagdoll() and IsValid(ent:GetDTEntity(0)) and ent:GetDTEntity(0):IsPlayer() then
		return false
	end
end)

hook.Add("CanTool", "Taser_Restrict", function(_, tr, _)
	local ent = tr.Entity
	if IsValid(ent) and ent:IsRagdoll() and IsValid(ent:GetDTEntity(0)) and ent:GetDTEntity(0):IsPlayer() then
		return false
	end
end)

hook.Add("PlayerSwitchWeapon", "Taser_Restrict", function(ply)
	if (SERVER and ply.istasered) or (CLIENT and IsValid(ply.TaseredEntity)) then
		return true
	end
end)