SWEP.ViewModel = "models/teh_maestro/popcorn.mdl"
SWEP.WorldModel = Model("models/teh_maestro/popcorn.mdl")
SWEP.Category = "Legendäre Waffen"
SWEP.Spawnable = true

SWEP.PrintName = "Popcorn"
SWEP.Instructions = "Linksklick um Popcorn zu essen.\nRechtsklick um den Eimer weg zu werfen."

SWEP.Primary.Delay = 2
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.HoldType = "slam"
SWEP.IsGun = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

local crisps_eat = Sound("crisps/eat.wav")
function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
        self.Owner:EmitSound(crisps_eat, 150)
		net.Start("Popcorn_Eat")
			net.WriteEntity(self.Owner)
		net.Broadcast()
		self.Owner:SetHealth(math.Clamp(self.Owner:Health() + 15, 0, self.Owner:GetMaxHealth()))
	end
end

local throwsound = Sound("weapons/slam/throw.wav")
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1)
	if !IsValid(self.Owner) then return end
	self:EmitSound(throwsound)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -8, 8, 0), util.SharedRandom(self:GetClass(), -8, 8, 0), 0))
	if !SERVER then return end
	local bucket = ents.Create("popcorn")
	if !IsValid(bucket) then return end
	bucket:SetPos(self.Owner:GetShootPos())
	bucket:SetOwner(self.Owner)
	bucket:SetPhysicsAttacker(self.Owner)
	bucket.Owner = self.Owner
	bucket:Spawn() 
	bucket:Activate()
	local phys = bucket:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(self.Owner:GetPhysicsObject():GetVelocity())
		phys:AddVelocity(self.Owner:EyeAngles():Forward() * 128 * phys:GetMass())
		phys:AddAngleVelocity(VectorRand() * 128 * phys:GetMass())
	end
	self.Owner:StripWeapon(self.ClassName)
end