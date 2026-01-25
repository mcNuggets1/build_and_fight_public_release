if not wac then return end

ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "KA-50 BlackShark"
ENT.Author				= "SentryGunMan"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model			= "models/sentry/ka-50.mdl"
ENT.EngineForce	= 36
ENT.Weight		= 21600
ENT.SmokePos	= Vector(28,0,108.48)
ENT.FirePos		= Vector(28,0,108.48)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(30,0,106),
	model = "models/sentry/ka-50_br.mdl"
}

ENT.TopRotor2 = {
	dir = 1,
	pos = Vector(30,0,158.5),
	angles = Angle(0,0,0),
	model = "models/sentry/ka-50_tr.mdl"
}

ENT.BackRotor = {
	dir = 1,
	pos = Vector(30,0,50),
	model = "models/props_junk/PopCan01a.mdl"
}

ENT.Seats = {
	{
		pos=Vector(116, 0, 52),
		exit=Vector(160,70,40),
		weapons={"Shipunov 2A42", "S-8"}
	}
}

ENT.Weapons = {
	["Shipunov 2A42"] = {
		class = "wac_pod_gatling",
		info = {
			Pods = {
				Vector(140,-35,43)
			},
			Sounds = {
				shoot = "WAC/KA-50/2A42.wav",
				stop = "WAC/KA-50/2A42_stop.wav"
			},
			FireRate = 600
		}
	},
	["S-8"] = {
		class = "wac_pod_hydra",
		info = {
			Pods = {
				Vector(14,-80,46),
				Vector(14,80,46),
				Sequential = true,
			},
		}
	}
}

ENT.Sounds={
	Start="WAC/KA-50/start.wav",
	Blades="WAC/KA-50/external.wav",
	Engine="WAC/KA-50/internal.wav",
	MissileAlert="WAC/Heli/heatseeker_track_warning.wav",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="WAC/Heli/fire_alarm_tank.wav",
	LowHealth="WAC/Heli/fire_alarm.wav",
	CrashAlarm="WAC/Heli/laser_warning.wav"
}