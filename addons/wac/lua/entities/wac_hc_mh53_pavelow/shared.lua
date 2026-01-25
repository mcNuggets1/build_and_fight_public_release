if not wac then return end

ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "MH-53 Sea Stallion"
ENT.Author				= "WeltEnSTurm"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Spawnable			= true
ENT.AdminSpawnable	= true

ENT.Model			= "models/bf2/helicopters/MH-53J Pave Low IIIE/mh53_b.mdl"
ENT.SmokePos		= Vector(10,0,175)
ENT.FirePos		= Vector(10,0,180)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(0,0,168.5),
	model = "models/bf2/helicopters/MH-53J Pave Low IIIE/mh53_r.mdl"
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-691,22,236),
	model = "models/bf2/helicopters/mh-53j pave low iiie/mh53_tr.mdl"
}

ENT.Seats = {
	{
		pos=Vector(256,-30,70),
		exit=Vector(250,-100,20),
	},
	{
		pos=Vector(256,32,70),
		exit=Vector(250,100,20),
	},
	{
		pos=Vector(81.58,-38,30),
		ang=Angle(0,90,0),
		exit=Vector(81.58,0,30),
	},
	{
		pos=Vector(81.58,38,30),
		ang=Angle(0,-90,0),
		exit=Vector(81.58,0,30),
	},
	{
		pos=Vector(43.72,38,30),
		ang=Angle(0,-90,0),
		exit=Vector(43.72,0,30),
	},
	{
		pos=Vector(-60.01,-38,30),
		ang=Angle(0,90,0),
		exit=Vector(-60.01,0,30),
	},
	{
		pos=Vector(-160.01,-38,30),
		ang=Angle(0,90,0),
		exit=Vector(-60.01,0,30),
	},
	{
		pos=Vector(-160.01,38,30),
		ang=Angle(0,-90,0),
		exit=Vector(-160.01,0,30),
	},
	{
		pos=Vector(-350,0,20),
		ang=Angle(0,180,0),
		exit=Vector(-340,0,20),
	},
}

ENT.Sounds = {
	Start="WAC/pavelow/start.wav",
	Blades="WAC/pavelow/external.wav",
	Engine="WAC/pavelow/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3",
}

function ENT:DrawWeaponSelection() end
