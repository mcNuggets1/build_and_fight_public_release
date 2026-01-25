if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Riot Schild"
SWEP.Category = "Legendäre Waffen"
SWEP.Instructions = "Linksklick zum Angreifen.\nRechtsklick um die Sichtbarkeit zu Konfigurieren."
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/bshields/rshield.mdl")
SWEP.WorldModel = Model("models/bshields/rshield.mdl")

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.Slot = 5
SWEP.SlotPos = 15
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Primary.Damage = 20
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ShieldHP = 600
SWEP.CanVisToggle = 0
SWEP.VisToggle = false
SWEP.HitDistance = 55
SWEP.IsShield = true

local function riotshield_remove(shield)
	if !IsValid(shield) then return end
	local hp, max_hp = shield:Health(), shield.MaxHP
	shield:Remove()
	return hp, max_hp
end

if SERVER then
	util.AddNetworkString("riot_shield_info")
end

if CLIENT then
	surface.CreateFont("riot_shield.HUD", {
		font = "Roboto Cn",
		size = 20
	})

	net.Receive("riot_shield_info", function()
		if LocalPlayer():IsValid() then
			LocalPlayer().riot_shieldIndex = net.ReadUInt(16)	
		end
	end)
end

local shields = {
	{
		["angles"] = Angle(5,7,-16),
		["position"] = Vector(-3,8,-3)
	},
	{
		["angles"] = Angle(-4,0,0),
		["position"] = Vector(6,1,-12)
	}
}

local SwingSound = Sound("WeaponFrag.Throw")
local HitSound = Sound("Flesh.ImpactHard")

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Hit")
end

function SWEP:Initialize()
	self:SetHoldType("melee2")
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

local ShieldIcon = Material("bshields/ui/riot_shield", "smooth")
local BackgroundIcon = Material("bshields/ui/background")
function SWEP:DrawHUD()
	surface.SetDrawColor(255,255,255,200)	
	surface.SetMaterial(BackgroundIcon)
	surface.DrawTexturedRect(ScrW()/2-ScrH()/10, ScrH()/2-ScrH()/30+ScrH()/3, ScrH()/5, ScrH()/15)
	surface.SetDrawColor(255,255,255,125)
	draw.SimpleTextOutlined("[LMB] ANGREIFEN", "riot_shield.HUD", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/22, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	surface.SetMaterial(ShieldIcon)
	surface.DrawTexturedRect(ScrW()/2-ScrH()/10.2, ScrH()/2-ScrH()/32+ScrH()/3, ScrH()/16, ScrH()/16) 
	if (self.VisToggle) then
		draw.SimpleTextOutlined("[RMB] UNSICHTBAR", "riot_shield.HUD", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/48, Color(255, 255, 255, 25), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	else
		draw.SimpleTextOutlined("[RMB] UNSICHTBAR", "riot_shield.HUD", ScrW()/2-ScrH()/32, ScrH()/2-ScrH()/28+ScrH()/3+ScrH()/48, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(20,20,20,255)) 
	end
end

function SWEP:PreDrawViewModel(vm)
	if !IsValid(vm) then return end
	local ply = LocalPlayer()
	local shield = ply.riot_shieldIndex and Entity(ply.riot_shieldIndex)
	if !IsValid(shield) then return end
	local col = shield:GetColor()
	col.a = self.VisToggle and 125 or 255
	shield:SetColor(col)
end

function SWEP:BuildShield()
	riotshield_remove(self.Shield)
	local owner = self:GetOwner()
	local owner_tb = owner:GetTable()
	local holdtype = 0
	owner_tb.riot_shield = ents.Create("riot_shield_static")
	if !IsValid(owner_tb.riot_shield) then return end
	owner_tb.riot_shield.Model = "models/bshields/rshield.mdl"
	owner_tb.riot_shield.Mass = 30
	owner_tb.riot_shield:SetCollisionGroup(COLLISION_GROUP_WORLD)
	owner_tb.riot_shield:SetMoveType(MOVETYPE_NONE)
	owner_tb.riot_shield:SetPos(owner:GetPos())
	local att = owner:LookupAttachment("anim_attachment_RH")
	if (att == 0) then
		holdtype = 1
	end
	if (holdtype == 0) then
		owner_tb.riot_shield:SetParent(owner, att)
		owner_tb.riot_shield:SetLocalAngles(shields[1].angles)
		owner_tb.riot_shield:SetLocalPos(shields[1].position)
	else
		att = owner:LookupAttachment("forward") != 0 and owner:LookupAttachment("forward") or owner:LookupAttachment("eyes") != 0 and owner:LookupAttachment("eyes")
		if (att == 0) then
			owner_tb.riot_shield:Remove()
			owner_tb.riot_shield = nil
			return
		end
		owner_tb.riot_shield:SetParent(owner, att)
		owner_tb.riot_shield:SetLocalAngles(shields[2].angles)
		owner_tb.riot_shield:SetLocalPos(shields[2].position)
	end
	owner_tb.riot_shield.holdtype = holdtype
	owner_tb.riot_shield.pos = {owner_tb.riot_shield:GetLocalAngles(), owner_tb.riot_shield:GetLocalPos()}
	owner_tb.riot_shield.model = owner:GetModel()
	owner_tb.riot_shield:Spawn()
	self.HP = self.HP or self.ShieldHP
	owner_tb.riot_shield:SetHealth(self.HP)
	owner_tb.riot_shield.MaxHP = self.MaxHP
	owner_tb.riot_shield:ColorShield()

	self.Shield = owner_tb.riot_shield

	net.Start("riot_shield_info")
		net.WriteUInt(owner_tb.riot_shield:EntIndex(), 16) 
	net.Send(owner)
end

function SWEP:Deploy()
	self.CanVisToggle = 0
	self.VisToggle = false
	self.HP = self.HP or self.ShieldHP
	self.MaxHP = self.ShieldHP
	if SERVER then
		timer.Simple(0, function()
			if IsValid(self) and IsValid(self.Owner) and self.Owner:GetActiveWeapon() == self then
				self:BuildShield()
			end
		end)
	end
	return true
end

function SWEP:Think()
	local owner = self:GetOwner()
	if owner:IsValid() then
		if owner.riot_shield and owner:GetModel() != owner.riot_shield.model then
			self:BuildShield()
		end
	end
	local hit = self:GetHit()
	if (hit > 0 and CurTime() > hit) then
		self:DealDamage()
		self:SetHit(0)
	end
end

function SWEP:PrimaryAttack()
	local owner = self.Owner
	if !IsValid(owner) then return end
	owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		if !IsValid(owner.riot_shield) then return end
		if owner.riot_shield.holdtype == 0 and owner:LookupAttachment("anim_attachment_RH") > 0 then
			owner.riot_shield:SetLocalAngles(Angle(6,-34,-12)) 
			owner.riot_shield:SetLocalPos(Vector(4,8,-1)) 
			timer.Simple(0.4,function()
				if !IsValid(owner) or !IsValid(owner.riot_shield) then return end
				owner.riot_shield:SetLocalAngles(owner.riot_shield.pos[1]) 
				owner.riot_shield:SetLocalPos(owner.riot_shield.pos[2]) 
			end)
		end
	end
	self:EmitSound(SwingSound)
	self:SetHit(CurTime() + 0.2)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:DealDamage()
	local owner = self.Owner
	owner:LagCompensation(true)

	local shield
	if SERVER then
		shield = owner.riot_shield
	elseif LocalPlayer().riot_shieldIndex then
		shield = Entity(LocalPlayer().riot_shieldIndex)
	end
	if !IsValid(shield) then return end

	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
		mask = MASK_SHOT_HULL,
		filter = {owner, shield}
	})

	if (!IsValid(tr.Entity)) then
		tr = util.TraceHull({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8),
			mask = MASK_SHOT_HULL,
			filter = {owner, shield}
		})
	end

	if (tr.Hit and !(game.SinglePlayer() and CLIENT)) then
		self:EmitSound(HitSound)
	end

	if (SERVER and IsValid(tr.Entity)) then
		local dmginfo = DamageInfo()

		local attacker = owner
		if (!IsValid(attacker)) then attacker = self end
		dmginfo:SetAttacker(attacker)

		dmginfo:SetInflictor(self)
		dmginfo:SetDamage(self.Primary.Damage * math.Rand(0.9, 1.1))

		local pos = owner:GetShootPos()
		local dest = pos + (owner:GetAimVector() * 48)
		tr.Entity:DispatchTraceAttack(dmginfo, pos + (owner:GetAimVector() * 3), dest)

	end

	if (SERVER and IsValid(tr.Entity)) then
		local phys = tr.Entity:GetPhysicsObject()
		if (IsValid(phys)) then
			phys:ApplyForceOffset(owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos)
		end
	end

	owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()
	if CLIENT then
		if self.CanVisToggle > CurTime() then return end
		surface.PlaySound("weapons/smg1/switch_single.wav")
		if !self.VisToggle then
			self.VisToggle = true
		else
			self.VisToggle = false
		end
		self.CanVisToggle = CurTime() + 0.2
	end
end

function SWEP:ShouldDrawViewModel()
	local ply = LocalPlayer()
	local shield = ply.riot_shieldIndex and Entity(ply.riot_shieldIndex)
	if !IsValid(shield) then return end
	local col = shield:GetColor()
	col.a = self.VisToggle and 125 or 255
	shield:SetColor(col)
end

if CLIENT then return end

function SWEP:Holster()
	self.HP = riotshield_remove(self.Shield)
	return true
end

function SWEP:OnRemove()
	self.HP = riotshield_remove(self.Shield)
	return true
end

function SWEP:PreDrop()
	self.HP = riotshield_remove(self.Shield)
	return true
end