if not wac then return end

ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.PrintName			= "Curtiss JN-4 Jenny"
ENT.Author				= "}{ornet/Vest"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Spawnable			= true
ENT.AdminSpawnable	= true

ENT.Model			= "models/curtiss/jenny_jn4.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.RotorModel		= "models/curtiss/jenny_prop.mdl"
ENT.TopRotorDir        = 1
ENT.rotorPos	= Vector(62, 0, 0)
ENT.BackRotorPos	= Vector(8, 0, -48)
ENT.EngineForce	= 240
ENT.Weight		= 761
ENT.SmokePos		= Vector(47, 0, 0)
ENT.FirePos		= Vector(47, 0, 0)

ENT.Wheels = {
    {
        mdl="models/Curtiss/jenny_wheels.mdl",
        pos=Vector(8,0,-48),
        friction=1,
        mass=150,
    },
}

ENT.Agility = {
	Thrust = 10
}

ENT.Seats = {
	{
		pos=Vector(-60, 0, -10),
		exit=Vector(-78,42,-48),
	},
	{
		pos=Vector(-15, 0, -10),
		exit=Vector(-78,-42,-48),
	},
}

ENT.Sounds={
	Start="WAC/jenny/start.wav",
	Blades="",
	Engine="WAC/jenny/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3",
}
