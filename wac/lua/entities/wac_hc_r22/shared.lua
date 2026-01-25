if not wac then return end

ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "Robinson R22"
ENT.Author				= "Dr. Matt"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Spawnable			= true
ENT.AdminSpawnable	= true

ENT.Model            = "models/r22/r22bodi.mdl"
ENT.EngineForce        = 22
ENT.Weight            = 635
ENT.SmokePos        = Vector(-70,0,48)
ENT.FirePos            = Vector(-75,0,48)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(-18,0,110),
	model = "models/r22/r22main2.mdl"
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-214,7,75),
	model = "models/r22/r22side2.mdl"
}

ENT.Seats = {
	{
		pos=Vector(4, -10, 30),
		exit=Vector(5,-60,10),
	},
	{
		pos=Vector(4, 10, 30),
		exit=Vector(5,60,10),
    }
}

ENT.Sounds = {
	Start="WAC/r22/start.wav",
	Blades="WAC/r22/external.wav",
	Engine="WAC/r22/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3",
}

function ENT:DrawWeaponSelection() end
