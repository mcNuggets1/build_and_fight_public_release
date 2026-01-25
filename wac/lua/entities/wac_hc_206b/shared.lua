if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.PrintName			= "Bell 206B"
ENT.Author				= "SentryGunMan, Dr. Matt"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model            = "models/206b/bell.mdl"
ENT.RotorWidth		= 190
ENT.EngineForce        = 34
ENT.Weight            = 1451
ENT.SmokePos        = Vector(-84,0,110)
ENT.FirePos            = Vector(-86,0,110)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(-37,2,121),
	model = "models/206b/206mp2.mdl"
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-290.5,8,81.5),
	model = "models/206b/206sp2.mdl"
}

ENT.thirdPerson = {
	distance = 400
}

ENT.Seats = {
	{
		pos=Vector(12, -12, 42),
		exit=Vector(30,-80,10),
	},
	{
		pos=Vector(12, 16, 42),
		exit=Vector(30,80,10),
	},
	{
		pos=Vector(-30, 15, 40),
		ang=Angle(-30,0,0),
		exit=Vector(-25,80,10),
	},
	{
		pos=Vector(-30, 2, 40),
		ang=Angle(-90,0,0),
		exit=Vector(-25,80,10),
	},
	{
		pos=Vector(-30, -10, 40),
		ang=Angle(-30,0,0),
		exit=Vector(-25,-80,10),
	},
}

ENT.Sounds={
	Start="WAC/Heli/h6_start.wav",
	Blades="WAC/bell206b/external.wav",
	Engine="WAC/bell206b/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3",
}

function ENT:DrawWeaponSelection() end