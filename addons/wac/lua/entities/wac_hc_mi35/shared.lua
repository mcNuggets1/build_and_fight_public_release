if not wac then return end

ENT.Base 			= "wac_hc_base"
ENT.Type 			= "anim"
ENT.PrintName		= "Mil Mi-35"
ENT.Author			= "SentryGunMan,Nirrti"
ENT.Category		= wac.aircraft.spawnCategoryC
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model			= "models/sentry/mi-35.mdl"
ENT.SmokePos		= Vector(-7.5,0,155)
ENT.FirePos			= Vector(-7.5,0,155)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(-7.5,0,160),
	model = "models/sentry/mi-35_tr.mdl"
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-415.5,25,174.5),
	model = "models/sentry/mi-35_rr.mdl"
}

ENT.Seats = {
	{
		pos=Vector(125, 0, 68),
		exit=Vector(125, 70, 0),
		weapons={"S-5"},
	},
	{
		pos=Vector(180, 0, 40),
		exit=Vector(180, 70, 0),
		weapons={"2A42", "9M17 Phalanga"},
	},
}


ENT.Weapons = {
	["S-5"] = {
		class = "wac_pod_hydra",
		info = {
			Sequential = true,
			Pods = {
				Vector(3.22,95,60),
				Vector(3.22,-95,60)
			}
		},
	},
	["9M17 Phalanga"] = {
		class = "wac_pod_hellfire",
		info = {
			Sequential = true,
			Pods = {
				Vector(-15,152.5,55),
				Vector(-15,-152.5,55)
			},
		},
	},
	["2A42"] = {
		class = "wac_pod_aimedgun",
		info = {
			ShootPos = Vector(219,0,34),
			ShootOffset = Vector(25,0,0),
			FireRate = MG_Vehicles.Config:GetFireRate("heli_t2", "2A42 MILMI"),
			Sounds = {
				spin = "",
				shoot1p = "WAC/cannon/havoc_cannon_1p.wav",
				shoot3p = "WAC/cannon/havoc_cannon_3p.wav"
			}
		}
	},
}

ENT.WeaponAttachments = {

	gunMount1 = {
		model = "models/sentry/mi-35_gun1.mdl",
		pos = Vector(219,0,34),
	},
	
	gunMount2 = {
		model = "models/sentry/mi-35_gun2.mdl",
		pos = Vector(219,0,34),
		localTo = "gunMount1",
	},
	
}

ENT.Camera = {
	model = "models/props_junk/PopCan01a.mdl",
	pos = Vector(220,0,50),
	offset = Vector(-1,0,0),
	viewPos = Vector(20, 0, 0),
	maxAng = Angle(45, 90, 0),
	minAng = Angle(-2, -90, 0),
	seat = 2
}

ENT.Sounds={
	Start="WAC/mi35/start.wav",
	Blades="WAC/mi35/external.wav",
	Engine="WAC/mi35/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="WAC/Heli/fire_alarm_tank.wav",
	LowHealth="WAC/Heli/fire_alarm.wav",
	CrashAlarm="WAC/Heli/FireSmoke.wav",
}