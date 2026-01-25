if not wac then return end

ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"

ENT.PrintName			= "Aircreation 582SL"
ENT.Author				= "}{ornet/Vest,Nikke"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Contact    			= ""
ENT.Purpose 			= ""
ENT.Instructions 		= ""
ENT.Spawnable			= true
ENT.AdminSpawnable	= true

ENT.Model			= "models/ultralight/ultralight.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.RotorModel		= "models/ultralight/ultralight_propeller2.mdl"
ENT.TopRotorDir		= 1
ENT.rotorPos		= Vector(-51,-0.25,50)
ENT.BackRotorPos	= Vector(18, 0, 24)
ENT.EngineForce	= 240
ENT.Weight		= 1500
ENT.SmokePos	= Vector(-47,-0.25,50)
ENT.FirePos		= Vector(-47,-0.25,50)


ENT.Wheels={
    {
        mdl="models/BF2/helicopters/Mil Mi-28/mi28_w2.mdl",
        pos=Vector(-27.5,37.5,8),
        friction=0,
        mass=130,
    },
    {
        mdl="models/BF2/helicopters/Mil Mi-28/mi28_w2.mdl",
        pos=Vector(-27.5,-37.5,8),
        friction=0,
        mass=130,
    },
    {
        mdl="models/BF2/helicopters/Mil Mi-28/mi28_w2.mdl",
        pos=Vector(49,0,10),
        friction=0,
        mass=170,
    },
}

ENT.Agility = {
	Thrust = 10
}

ENT.Seats = {
	{
		pos=Vector(18, 0, 24),
		exit=Vector(18,70,5),
	},
	{
		pos=Vector(-3, 0, 33),
		exit=Vector(-3,-70,5),
	},
}

ENT.Sounds={
	Start="WAC/ultralight/start.wav",
	Blades="",
	Engine="WAC/ultralight/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3",
}
