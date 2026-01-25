if not wac then return end

ENT.Base = "wac_hc_base"
ENT.Type = "anim"
ENT.PrintName = "Hughes 500D"
ENT.Author = "Hornet/Vest"
ENT.Category = wac.aircraft.spawnCategoryC
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/military2/air/air_h500.mdl"
ENT.EngineForce	= 44
ENT.Weight = 1361
ENT.SmokePos = Vector(-70,0,-12)
ENT.FirePos = Vector(0,0,46)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(0,0,48),
	model = "models/military2/air/air_h500_r.mdl"
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-185,3.4,13.2),
	model = "models/military2/air/air_h500_sr.mdl"
}

ENT.Seats = {
	{
		pos=Vector(28, 14.5, -14),
		exit=Vector(28,70,-56),
	},
	{
		pos=Vector(28, -14.5, -14),
		exit=Vector(28,-70,-56),
	},
	{
		pos=Vector(-8, -11, -17),
		exit=Vector(-10,-70,-56),
	},
	{
		pos=Vector(-8, 11, -17),
		exit=Vector(-10,70,-56),
	},
}

ENT.Sounds={
	Start = "WAC/Heli/h6_start.wav",
	Blades = "WAC/Heli/heli_loop_ext.wav",
	Engine = "WAC/Heli/heli_loop_int.wav",
	MissileAlert = "HelicopterVehicle/MissileNearby.mp3",
	MissileShoot = "HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm = "HelicopterVehicle/MinorAlarm.mp3",
	LowHealth = "HelicopterVehicle/LowHealth.mp3",
	CrashAlarm = "HelicopterVehicle/CrashAlarm.mp3",
}