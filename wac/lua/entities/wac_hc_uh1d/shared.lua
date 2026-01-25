if not wac then return end

ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "UH-1D Huey"
ENT.Author				= "SentryGunMan"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Spawnable			= true
ENT.AdminSpawnable	= true

ENT.Model			= "models/sentry/uh-1d.mdl"
ENT.EngineForce	= 30
ENT.Weight		= 9200
ENT.SmokePos	= Vector(-85,0,102)
ENT.FirePos		= Vector(-85,0,102)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(2,0,142),
	model = "models/sentry/uh-1d_tr.mdl"
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-335,6,156),
	model = "models/sentry/uh-1d_rr.mdl"
}

ENT.Seats = {
	{
		pos=Vector(95,-24.5,47),
		exit=Vector(100,-120,10),
	},
	{
		pos=Vector(95, 24.5, 47),
		exit=Vector(100,120,10),
	},
	{
		pos=Vector(18,-30,47),
		exit=Vector(20,-120,10),
	},
	{
		pos=Vector(18, -10,47),
		exit=Vector(20,-120,10),
	},
	{
		pos=Vector(18, 10,47),
		exit=Vector(20,-120,10),
	},
	{
		pos=Vector(18, 30, 47),
		exit=Vector(20,120,10),
	},
	{
		pos=Vector(-10, 26, 47),
		ang=Angle(0,90,0),
		exit=Vector(0,120,10),
	},
	{
		pos=Vector(-10, -26, 47),
		ang=Angle(0,-90,0),
		exit=Vector(0,-120,10),
	},
}

ENT.Sounds = {
	Start="WAC/uh1d/start.wav",
	Blades="WAC/uh1d/external.wav",
	Engine="WAC/uh1d/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="ah64d/rocket_fire.wav",
	MinorAlarm="WAC/Heli/fire_alarm_tank.wav",
	LowHealth="WAC/Heli/fire_alarm.wav",
	CrashAlarm="WAC/Heli/FireSmoke.wav"
}

function ENT:DrawWeaponSelection() end