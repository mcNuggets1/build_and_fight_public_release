if not wac then return end

ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"

ENT.PrintName			= "BD-5J Micro Jet"
ENT.Author				= "Dr. Matt"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Contact    			= ""
ENT.Purpose 			= ""
ENT.Instructions 		= ""
ENT.Spawnable			= true
ENT.AdminSpawnable	= true

ENT.Model			= "models/drmatt/bd5/body.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.TopRotorDir        = 1
ENT.rotorPos	= Vector(70, 0, 10)
ENT.BackRotorPos	= Vector(8, 0, -48)
ENT.EngineForce	= 350
ENT.Weight		= 300
ENT.SmokePos		= Vector(-138.73,-1,36.81)
ENT.FirePos		= Vector(-138.73,-1,36.81)

ENT.EngineWeight = {
	Weight = 100,
	Position = Vector(100,0,0)
}

ENT.Agility = {
	Thrust = 15
}

ENT.Wheels={
    {
        mdl="models/drmatt/bd5/wheel.mdl",
        pos=Vector(105,-5,-45.6),
        friction=1,
        mass=40,
    },
    {	mdl="models/drmatt/bd5/wheel.mdl",
        pos=Vector(-12,-57,-39),
        friction=1,
        mass=40,
    },
    {	mdl="models/drmatt/bd5/wheel.mdl",
        pos=Vector(-9,50,-39),
        friction=1,
        mass=40,
    },
}

ENT.Seats = {
	{
		pos=Vector(10,-5,-5),
		exit=Vector(62,49,-40),
	},
}

ENT.Sounds={
	Start="WAC/bd5j/start.wav",
	Blades="WAC/bd5j/external.wav",
	Engine="WAC/bd5j/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3"
}

// heatwave
if CLIENT then
	local cureffect=0
	function ENT:Think()
		self:base("wac_pl_base").Think(self)
		local throttle = self:GetNWFloat("up", 0)
		local active = self:GetNWBool("active", false)
		local v=LocalPlayer():GetVehicle()
		if IsValid(v) then
			local ent=v:GetNWEntity("wac_aircraft")
			if ent==self and active and throttle > 0.2 and CurTime()>cureffect then
				cureffect=CurTime()+0.02
				local ed=EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(Vector(-165,-5,36.81)) // offset
				ed:SetRadius(10)
				ed:SetMagnitude(throttle)
				util.Effect("wac_heatwave", ed)
			end
		end
	end
end

function ENT:DrawWeaponSelection() end