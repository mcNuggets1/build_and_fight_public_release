MG_Vehicles = MG_Vehicles or {}
MG_Vehicles.Config = MG_Vehicles.Config or {}

MG_Vehicles.Config.Stats = { -- Eine Level Klasse
	-- Fahrzeuge
	["vehicle_light"] = {
		name = "Leichtfahrzeuge",
		limit = 4,
		hp = 750,
	},
	["vehicle_medium"] = {
		name = "Standardfahrzeuge",
		limit = 4,
		hp = 1500,
	},
	["vehicle_medium_armed"] = {
		name = "Standardfahrzeuge (Bewaffnet)",
		limit = 2,
		hp = 1500,
		weapons = {
			["Weapon"] = {
				damage = 0,
			}
		},
	},
	["vehicle_heavy"] = {
		name = "Schwerfahrzeuge",
		limit = 4,
		hp = 2500,
	},
	["vehicle_heavy_armed"] = {
		name = "Schwerfahrzeuge (Bewaffnet)",
		limit = 2,
		hp = 2500,
		weapons = {
			["RocketLauncher"] = {
				damage = 100, -- used in gred_simfphys_man_lars, gred_simfphys_roland
			},
		}
	},

	-- Lieferung
	["vehicle_delivery"] = {
		name = "Lieferungsfahrzeuge (Klein)",
		limit = 3,
		hp = 1500,
	},
	["vehicle_delivery_big"] = {
		name = "Lieferungsfahrzeuge (Groß)",
		limit = 1,
		hp = 1500,
	},

	-- Luft
	["heli_light"] = {
		name = "Helikopter (Leicht)",
		limit = 0,
		hp = 500,
		weapons = {},
	},
	["jet_light"] = {
		name = "Jets (Leicht)",
		limit = 0,
		hp = 600,
		weapons = {},
	},
	["heli_medium"] = {
		name = "Helikopter (Mittel)",
		limit = 0,
		hp = 800,
		weapons = {},
	},
	["jet_medium"] = {
		name = "Jets (Mittel)",
		limit = 0,
		hp = 1000,
		weapons = {},
	},
	--[[
	["heli_heavy"] = {
		name = "Helikopter (Schwer)",
		limit = 0,
		hp = 0,
		weapons = {},
	},
	["jet_heavy"] = {
		name = "Jets (Schwer)",
		limit = 0,
		hp = 0,
		weapons = {},
	},
	]]--
	["heli_t1"] = {
		name = "Helikopter (Tier 1)",
		limit = 0,
		hp = 800,
		weapons = {
			["M134"] = { -- pod_gatling base
				damage = 20,
				ammo = 800,
				rate = 4000,
			},
			["M61A1"] = { -- F/A 18-F Super Hornet
				damage = 20,
				ammo = 800,
				rate = 4000,
			},

			["Hydra 70"] = { -- pod_hydra base
				damage = 150,
				ammo = 14,
				rate = 120,
			},
			["SNEB"] = { -- Eurocopter
				damage = 130,
				ammo = 14,
				rate = 120,
			},
			["S-8"] = { -- MI28 Havoc
				damage = 130,
				ammo = 40,
				rate = 300,
			},

			["Hellfire"] = { -- pod_hellfire base
				damage = 150,
				ammo = 8,
				rate = 10,
			},
			["9M120"] = { -- MI28 Havoc
				damage = 130,
				ammo = 8,
				rate = 10,
			},

			["M197"] = { -- pod_aimedgun base
				damage = 60,
				ammo = 750,
				rate = 730,
			},
			["2A42"] = { -- Eurocopter
				damage = 60,
				ammo = 750,
				rate = 300,
			},
		},
	},
	["jet_t1"] = {
		name = "Jets (Tier 1)",
		limit = 0,
		hp = 1000,
		weapons = {
			["M134"] = { -- pod_gatling base
				damage = 20,
				ammo = 800,
				rate = 4000,
			},
			["M61 Vulcan"] = { -- F-16C Falcon, F-4 Phantom II -- TO Check if same
				damage = 20,
				ammo = 800,
				rate = 4000,
			},
			["M61 Vulcan HORNET"] = { -- (wac_m61 base) F-18C Hornet
				damage = 30,
				ammo = 300,
				rate = 1000,
			},
			["M61 Vulcan FA22"] = { -- FA22
				damage = 169,
				ammo = 480,
				rate = 2000,
			},

			["Hydra 70"] = { -- pod_hydra base
				damage = 150,
				ammo = 14,
				rate = 120,
			},
			["CRV7"] = { -- AV8B Harrier II VTOL
				damage = 150,
				ammo = 30,
				rate = 300,
			},

			["Hellfire"] = { -- pod_hellfire base
				damage = 150,
				ammo = 8,
				rate = 10,
			},
			["AGM-88 HARM"] = { -- AV8B Harrier II VTOL
				damage = 150,
				ammo = 2,
				rate = 10,
			},

			["M197"] = { -- pod_aimedgun base
				damage = 60,
				ammo = 750,
				rate = 730,
			},

			["Gredwitch's MG"] = { -- pod_mg base
				damage = 20,
				ammo = 425,
				rate = 9999,
			},
			["Browning M2"] = { -- P-47D Thunderbolt
				damage = 20,
				ammo = 2500,
				rate = 5000,
			},

			["Gredwitch's Rockets"] = { -- pod_grocket base
				damage = 250,
				ammo = 1,
				rate = 220,
			},
			["RP3 Rockets"] = { -- P-47D Thunderbolt
				damage = 200,
				ammo = 10,
				rate = 90,
			},

			["250lb bombs"] = { -- P-47D Thunderbolt
				damage = 8000,
				--ammo = 0, -- done via pods in the weapon 
				rate = 120,
			},

			["GAU-12/U Equalizer"] = { -- pod_mm1_gau12 base
				damage = 64,
				ammo = 300,
				rate = 1800,
			},
			["GAU-12 Equalizer"] = { -- AV8B Harrier II VTOL
				damage = 64,
				ammo = 300,
				rate = 1800,
			},

			["CBU-52U"] = { -- pod_mm1_cbu52
				--damage = 0,
				--ammo = 0, -- done via pods in the weapon
				rate = 120,
			},
			["CBU-52U VTOL"] = { -- AV8B Harrier II VTOL
				--damage = 0,
				--ammo = 0, -- done via pods in the weapon
				rate = 150
			},

			["AN/M1919 Browning"] = { -- (pod_sbu1 base) SBU-1 Corsair
				damage = 20,
				ammo = 500,
				rate = 1200,
			},

			["AN-M57 bomb"] = { -- (pod_m57 base) SBU-1 Corsair
				--damage = 0,
				--ammo = 0, -- done via pods in the weapon
				rate = 100,
			},

			["Bomb"] = { -- (pod_bomb base) F-4 Phantom II
				--damage = 0,
				--ammo = 0, -- done via pods in the weapon
				rate = 120,
			},

			["AGM65"] = { -- (aron_wac_maverick base) F-18C Hornet
				damage = 5000,
				ammo = 2,
				rate = 10,
			},

			["AIM9M"] = { -- (aron_wac_aim9 base) F-18C Hornet
				damage = 1500,
				ammo = 4,
				rate = 20,
			},
			["AIM-9M/X FA22"] = { -- FA22
				damage = 557,
				ammo = 2,
				rate = 120,
			},
			["AIM-120C FA22"] = { -- FA22
				damage = 789,
				ammo = 6,
				rate = 120,
			},
		},
	},
	["heli_t2"] = {
		name = "Helikopter (Tier 2)",
		limit = 0,
		hp = 1000,
		weapons = {
			["M134"] = { -- wac_pod_gatling base
				damage = 20,
				ammo = 800,
				rate = 4000,
			},

			["Hydra 70"] = { -- wac_pod_hydra base
				damage = 150,
				ammo = 14,
				rate = 120,
			},
			["AS MISSILE"] = { -- UTH-66 Blackfoot
				damage = 150,
				ammo = 18,
				rate = 500,
			},
			["AS MISSILE KROKODIL"] = { -- HP-48 Krokodil
				damage = 150,
				ammo = 64,
				rate = 400,
			},
			["S-5"] = { -- Mil Mi-35
				damage = 150,
				ammo = 14,
				rate = 120,
			},

			["Hellfire"] = { -- pod_hellfire base
				damage = 150,
				ammo = 8,
				rate = 10,
			},
			["9M120"] = { -- UTH-66 Blackfoot
				damage = 150,
				ammo = 20,
				rate = 500,
			},
			["9M17 Phalanga"] = { -- Mil Mi-35
				damage = 150,
				ammo = 8,
				rate = 10,
			},
			
			["M197"] = { -- UTH-66 Blackfoot
				damage = 40,
				ammo = 1000,
				rate = 1000,
			},

			["M197"] = { -- wac_pod_aimedgun base
				damage = 40,
				ammo = 750,
				rate = 730,
			},
			["2A42"] = { -- UTH-66 Blackfoot
				damage = 20,
				ammo = 1000,
				rate = 800,
			},
			["2A42 KROKODIL"] = { -- HP-48 Krokodil
				damage = 20,
				ammo = 1000,
				rate = 1000,
			},
			["2A42 MILMI"] = { -- Mil Mi-35
				damage = 20,
				ammo = 750,
				rate = 300,
			},
		},
	},
	["jet_t2"] = {
		name = "Jets (Tier 2)",
		limit = 0,
		hp = 1000,
		weapons = {
			["M134"] = { -- wac_pod_gatling base
				damage = 20,
				ammo = 800,
				rate = 4000,
			},

			["Hydra 70"] = { -- wac_pod_hydra base
				damage = 150,
				ammo = 14,
				rate = 120,
			},
			["S-5"] = { -- Su-39 Frogfoot
				damage = 130,
				ammo = 12,
				rate = 300,
			},

			["Hellfire"] = { -- wac_pod_hellfire base
				damage = 130,
				ammo = 8,
				rate = 10,
			},
			["AIM-7 Sparrow"] = { -- F-15E Strike Eagle
				damage = 130,
				ammo = 4,
				rate = 10,
			},
			["Kh-23"] = { -- Su-39 Frogfoot
				damage = 130,
				ammo = 4,
				rate = 10,
			},

			["M197"] = { -- wac_pod_aimedgun base
				damage = 60,
				ammo = 750,
				rate = 730,
			},

			["M61A1 Vulcan"] = { -- wac_f15e_m61 base
				damage = 130,
				ammo = 510,
				rate = 2000,
			},

			["GSh-30-2"] = { -- wac_pod_hawx_gsh302 base, Su-39 Frogfoot
				damage = 77,
				ammo = 250,
				rate = 300,
			},
 		},
	},

	-- Panzer
	["tanks_t1"] = {
		name = "Panzer (Tier 1)",
		limit = 2,
		hp = 3000,
		weapons = {
			["Cannon"] = {
				damage = 125,
			},
			["MG"] = {
				damage = 10,
			},
		},
	},

	-- APC
	["apc"] = {
		name = "Armored Personnel Carrier",
		limit = 0,
		hp = 0,
		weapons = false
	},

	["default"] = {
		hp = false,
		weapons = {},
	}
}

MG_Vehicles.Config.Vehicles = {
	["vehicle_light"] = {"sim_fphys_jeep_uscod_med", "sim_fphys_l4d_army_truck", "sim_fphys_l4d_95sedan", "sim_fphys_l4d_84sedan", "sim_fphys_l4d_69charger", "sim_fphys_l4d_crownvic", "sim_fphys_l4d_taxi_rural", "sim_fphys_l4d_pickup_4x4", "sim_fphys_technical2", "crsk_mercedes_250gd_wolf", "SnowdropEscape_Zaz968", "SnowdropEscape_Zaz968m"},
	["vehicle_medium"] = {"sim_fphys_ural_troop", "sim_fphys_l4d_hmmwv", "sim_fphys_l4d_pickup_b_78", "sim_fphys_l4d_pickup_2004", "sim_fphys_ural_cargo", "sim_fphys_technical1", "sim_fphys_l4d_news_van"},
	["vehicle_medium_armed"] = {"gred_simfphys_bulldog_nw", "gred_simfphys_bulldog_shiten"},
	["vehicle_heavy"] = {"sim_fphys_iveco_sf", "sim_fphys_l4d_apc", "bm_hummer", "bm_hummertow", "uaz_3170", "uaz_jag", "kamaz", "maz", "bm_M1075", "bm_M35", "bm_M35_canvas", "bm_M35_woodback", "gred_simfphys_dingo"},
	["vehicle_heavy_armed"] = {"gred_simfphys_man_lars", "gred_simfphys_roland", "sim_fphys_m142", "bm_lav", "perryn_bearcat_g3", "dk_ural", "simfphys_btr80"},
	["vehicle_delivery"] = {""},
	["vehicle_delivery_big"] = {""},
	["heli_light"] = {"wac_hc_littlebird_h500", "wac_hc_littlebird_mh6", "wac_hc_r22", "wac_hc_206b"},
	["jet_light"] = {"wac_pl_t45", "wac_pl_c172", "wac_pl_jenny"},
	["heli_medium"] = {"wac_hc_ch46_seaknight", "wac_hc_uh1d", "wac_hc_aw101_merlin_normal", "wac_hc_blackhawk_uh60", "wac_hc_uh1y_venom", "wac_hc_ch47_chinook", "wac_hc_mi17"},
	["jet_medium"] = {"wac_pl_t45"},
	--["heli_heavy"] = {""},
	--["jet_heavy"] = {""},
	["heli_t1"] = {"wac_pl_fa18", "wac_hc_rah66", "wac_hc_ec655", "wac_hc_mi28_havoc"},
	["jet_t1"] = {"wac_pl_f16", "wac_pl_p47d_bomber", "wac_hc_mm1_av8b", "wac_pl_sbu1", "wac_pl_f4", "aron_wac_f18", "wac_pl_hawx_fa22"},
	["heli_t2"] = {"wac_fg_uth66", "wac_hc_ah1w", "wac_hc_fg_hp48", "wac_hc_mi35"},
	["jet_t2"] = {"wac_pl_f15e2", "wac_pl_hawx_su39"},
	["tanks_t1"] = {"gred_simfphys_amx56_leclerc_s1", "gred_simfphys_amx30"},
	["apc"] = {}
}

MG_Vehicles.VehicleClassCache = {
	--["example_class"] = "vehicle_light",
}

MG_Vehicles.Config.SkinOverride = {
	["sim_fphys_ural_cargo"] = {
		["NATO"] = {0, 2, 3},
		["Terroristen"] = {1, 4, 5},
	},
}

function MG_Vehicles.Config:GetVehicleClass(class)
	if !class then return end

	if MG_Vehicles.VehicleClassCache[class] then
		return MG_Vehicles.VehicleClassCache[class]
	end

	for mg_vehclass, vehicles in pairs(MG_Vehicles.Config.Vehicles) do
		for _, vehicle in pairs(vehicles) do
			if vehicle == class then
				MG_Vehicles.VehicleClassCache[class] = mg_vehclass
				return mg_vehclass
			end
		end
	end

	MG_Vehicles.VehicleClassCache[class] = "default"
	return "default"
end

function MG_Vehicles.Config:GetVehicleHP(class)
	local vehclass = (MG_Vehicles.Config.Vehicles[class] and class or MG_Vehicles.Config:GetVehicleClass(class))
	if !vehclass or vehclass == "default" then return end

	local res = MG_Vehicles.Config.Stats[vehclass].hp
	if !res then
		ErrorNoHaltWithStack("[MG Vehicles] No HP value for vehicle class: "..tostring(class).."!")
		return
	end

	return res
end

function MG_Vehicles.Config:GetDamage(class, wep)
	local vehclass = (MG_Vehicles.Config.Vehicles[class] and class or MG_Vehicles.Config:GetVehicleClass(class))
	if !vehclass or vehclass == "default" then return end

	local weapon = MG_Vehicles.Config.Stats[vehclass].weapons[wep]
	if !weapon then
		ErrorNoHaltWithStack("[MG Vehicles] No weapon value for vehicle class: "..tostring(class).." with weapon: "..tostring(wep).."!")
		return
	end

	local res = weapon.damage
	if !res then
		ErrorNoHaltWithStack("[MG Vehicles] No damage value for vehicle class: "..tostring(class).." with weapon: "..tostring(wep).."!")
		return
	end

	return res
end

function MG_Vehicles.Config:GetAmmo(class, wep)
	local vehclass = (MG_Vehicles.Config.Vehicles[class] and class or MG_Vehicles.Config:GetVehicleClass(class))
	if !vehclass or vehclass == "default" then return end

	local weapon = MG_Vehicles.Config.Stats[vehclass].weapons[wep]
	if !weapon then
		ErrorNoHaltWithStack("[MG Vehicles] No weapon value for vehicle class: "..tostring(class).." with weapon: "..tostring(wep).."!")
	end

	local res = weapon.ammo
	if !res then
		ErrorNoHaltWithStack("[MG Vehicles] No ammo value for vehicle class: "..tostring(class).." with weapon: "..tostring(wep).."!")
		return
	end

	return res
end

function MG_Vehicles.Config:GetFireRate(class, wep)
	local vehclass = (MG_Vehicles.Config.Vehicles[class] and class or MG_Vehicles.Config:GetVehicleClass(class))
	if !vehclass or vehclass == "default" then return end
	
	local weapon = MG_Vehicles.Config.Stats[vehclass].weapons[wep]
	if !weapon then
		ErrorNoHaltWithStack("[MG Vehicles] No weapon value for vehicle class: "..tostring(class).." with weapon: "..tostring(wep).."!")
		return
	end

	local res = weapon.rate
	if !res then
		ErrorNoHaltWithStack("[MG Vehicles] No fire rate value for vehicle class: "..tostring(class).." with weapon: "..tostring(wep).."!")
		return
	end

	return res
end
