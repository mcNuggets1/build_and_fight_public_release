if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Goldkanone"
SWEP.Spawnable = true
SWEP.DrawCrosshair = true
SWEP.Purpose = "Vernichte deine Gegner und verarbeite sie zu Staub anstatt sie NUR zu töten!"
SWEP.Author = "Modern Gaming"
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = Model("models/weapons/w_physics.mdl")
SWEP.ViewModelFOV = 55
SWEP.HoldType = "physgun"
SWEP.Category = "Legendäre Waffen"
SWEP.Primary.Damage = 60
SWEP.Primary.Delay = 1.4
SWEP.Primary.Recoil = 2
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1.5)
end

function SWEP:PreDrawViewModel(vm, wep)
	vm:SetMaterial("models/debug/debugwhite")
	render.SetColorModulation(1, 1, 0)
end

function SWEP:PostDrawViewModel(vm, wep)
	vm:SetMaterial("")
	render.SetColorModulation(1, 1, 1)
end

function SWEP:DrawWorldModel(model)
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(255, 255, 0))
	self:DrawModel()
end

local fire = Sound("npc/strider/fire.wav")
function SWEP:PrimaryAttack()
	local owner = self.Owner
	if !IsValid(owner) or owner:WaterLevel() > 2 then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:SetAnimation(PLAYER_ATTACK1)
	owner:ViewPunch(Angle(-self.Primary.Recoil, 0, 0))
	self:EmitSound(fire)
	owner:LagCompensation(true)
	local tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = tr.start + owner:GetAimVector() * 16384
	tr.filter = owner
	tr.mins = Vector() * -1
	tr.maxs = Vector() * 1
	tr = util.TraceLine(tr)
	owner:LagCompensation(false)
	util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, owner)
	local ent = tr.Entity
	if IsFirstTimePredicted() then
		local vm = owner:GetViewModel()
		if IsValid(vm) then
			local tooldata = EffectData()
			tooldata:SetStart(tr.StartPos)
			tooldata:SetOrigin(tr.HitPos)
			tooldata:SetEntity(self)
			tooldata:SetAttachment(vm:LookupAttachment("muzzle"))
			util.Effect("ToolTracer", tooldata)
		end
		local edata = EffectData()
		edata:SetStart(owner:GetShootPos())
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.Normal)
		edata:SetSurfaceProp(tr.SurfaceProps)
		edata:SetHitBox(tr.HitBox)
		edata:SetEntity(tr.Entity)
		util.Effect("ImpactGunship", edata)
		util.Effect("HelicopterImpact", edata)
		if (ent:IsPlayer() or ent:IsNPC() or ent:IsRagdoll()) then
			util.Effect("BloodImpact", edata)
		end
	end
	if IsValid(ent) then
		self:MakeGold(ent)
	end
end

function SWEP:MakeGold(ent)
	if ent:IsPlayer() then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(self.Primary.Damage)
		dmginfo:SetAttacker(self.Owner)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamageType(DMG_DISSOLVE)
		if SERVER then
			ent:TakeDamageInfo(dmginfo)
		end
	else
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceOffset(self.Owner:GetAimVector() * 1000 * phys:GetMass(), ent:GetPos())
		end
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(self.Primary.Damage * 2)
		dmginfo:SetAttacker(self.Owner)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamageType(DMG_DISSOLVE)
		if SERVER then
			if ent:GetClass() == "func_breakable_surf" then
				ent:Fire("Shatter")
			end
			ent:TakeDamageInfo(dmginfo)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end