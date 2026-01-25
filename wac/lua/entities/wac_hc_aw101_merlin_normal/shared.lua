if not wac then return end

ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "AW-101 Merlin Normal Quality"
ENT.Author				= "Hypnoshizu"
ENT.Category			= "WAC Unoffical"
ENT.Spawnable			= true
ENT.AdminSpawnable	= true

ENT.Model			= "models/hypno/aw101/normal/aw101.mdl"
ENT.SmokePos		= Vector(-178,20,189)
ENT.FirePos		= Vector(-165,20,190)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(30,0,224),
	model = "models/hypno/aw101/normal/rotor.mdl",
	angles = Angle(3, 0, 0)
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-477.5,42,238.5),
	model = "models/hypno/aw101/normal/back_rotor.mdl"
}

ENT.Camera = {
	model = "models/hypno/aw101/normal/aw_cam.mdl",
	pos = Vector(309.93,0.15,23.5),
	offset = Vector(-1,2,0),
	viewPos = Vector(15, 0, 3.5),
	maxAng = Angle(45, 90, 0),
	minAng = Angle(-2, -90, 0),
	seat = 2
}

ENT.Seats = {
	{
		pos=Vector(228, -34, 77),
		exit=Vector(228, -100, 50),
		NoHud = true,
	},
	{
		pos=Vector(228, 34, 77),
		exit=Vector(228, 100, 50),
	},
	{
		pos=Vector(162.5, 36, 73),
		exit=Vector(162.5, 0, 70),
		ang=Angle(0,180,0),
	},
	{
		pos=Vector(159, -46, 73),
		exit=Vector(110,115,50),
		ang=Angle(0,90,0),
	},
	{
		pos=Vector(134, -46, 73),
		exit=Vector(134,-115,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(110, -46, 73),
		exit=Vector(110,-115,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(-11, -46, 73),
		exit=Vector(-11,-140,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(-35, -46, 73),
		exit=Vector(-35,-140,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(-59, -46, 73),
		exit=Vector(-59,-140,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(-83, -46, 73),
		exit=Vector(-83,-140,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(-107, -46, 73),
		exit=Vector(-107,-140,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(-131, -46, 73),
		exit=Vector(-131,-140,50),
		ang=Angle(0,90,0),
		NoHud = true,
	},
	{
		pos=Vector(115, 46, 73),
		exit=Vector(115,115,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(91, 46, 73),
		exit=Vector(91,115,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(16, 46, 73),
		exit=Vector(16,140,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(-6, 46, 73),
		exit=Vector(-6,140,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(-30, 46, 73),
		exit=Vector(-30,140,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(-54, 46, 73),
		exit=Vector(-54,140,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(-78, 46, 73),
		exit=Vector(-78,140,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(-104, 46, 73),
		exit=Vector(-104,140,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
	{
		pos=Vector(-128, 46, 73),
		exit=Vector(-128,140,50),
		ang=Angle(0,-90,0),
		NoHud = true,
	},
}

ENT.Sounds = {
	Start="aw101/start.wav",
	Blades="aw101/extern.wav",
	Engine="aw101/intern.mp3",
	MissileAlert="WAC/Heli/heatseeker_track_warning.wav",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="WAC/Heli/fire_alarm_tank.wav",
	LowHealth="WAC/Heli/fire_alarm.wav",
	CrashAlarm="WAC/Heli/laser_warning.wav"
}

function ENT:DrawWeaponSelection() end
