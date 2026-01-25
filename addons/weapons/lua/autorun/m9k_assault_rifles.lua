if CLIENT then
	local icol = Color(255, 255, 255, 255) 
	killicon.Add("m9k_acr", "vgui/hud/m9k_acr", icol)
	killicon.Add("m9k_ak47", "vgui/hud/m9k_ak47", icol)
	killicon.Add("m9k_ak74", "vgui/hud/m9k_ak74", icol)
	killicon.Add("m9k_amd65", "vgui/hud/m9k_amd65", icol)
	killicon.Add("m9k_an94", "vgui/hud/m9k_an94", icol)
	killicon.Add("m9k_auga3", "vgui/hud/m9k_auga3", icol)
	killicon.Add("m9k_f2000", "vgui/hud/m9k_f2000", icol)
	killicon.Add("m9k_fal", "vgui/hud/m9k_fal", icol)
	killicon.Add("m9k_famas", "vgui/hud/m9k_famas", icol)
	killicon.Add("m9k_g3a3", "vgui/hud/m9k_g3a3", icol)
	killicon.Add("m9k_g36", "vgui/hud/m9k_g36", icol)
	killicon.Add("m9k_l85", "vgui/hud/m9k_l85", icol)
	killicon.Add("m9k_m4a1", "vgui/hud/m9k_m4a1", icol)
	killicon.Add("m9k_m14sp", "vgui/hud/m9k_m14sp", icol)
	killicon.Add("m9k_m16a4_acog", "vgui/hud/m9k_m16a4_acog", icol)
	killicon.Add("m9k_m416", "vgui/hud/m9k_m416", icol)
	killicon.Add("m9k_scar", "vgui/hud/m9k_scar", icol)
	killicon.Add("m9k_tar21", "vgui/hud/m9k_tar21", icol)
	killicon.Add("m9k_usc", "vgui/hud/m9k_usc", icol)
	killicon.Add("m9k_val", "vgui/hud/m9k_val", icol)
	killicon.Add("m9k_vikhr", "vgui/hud/m9k_vikhr", icol)
	killicon.Add("m9k_winchester73", "vgui/hud/m9k_winchester73", icol)

	killicon.Add("m9k_galil", "vgui/hud/m9k_galil", icol)
	killicon.Add("m9k_aug", "vgui/hud/m9k_aug", icol)
	killicon.Add("m9k_sg552", "vgui/hud/m9k_sg552", icol)
end

sound.Add({
	name = "an94.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound =	Sound("weapons/an94/galil-1.wav")
})

sound.Add({
	name = "an94.double",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/an94/doubletap.wav")
})

sound.Add({
	name = "Weapon_an-94.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/an94/clipout.mp3")
})

sound.Add({
	name = "Weapon_an-94.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/an94/clipin.mp3")
})

sound.Add({
	name = "Weapon_an-94.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/an94/boltpull.mp3")
})

sound.Add({
	name = "Weapon_an-94.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/an94/draw.mp3")
})

sound.Add({
	name = "amd65.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/amd65/amd-1.wav")
})

sound.Add({
	name = "amd65.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/amd65/clipout.mp3")
})

sound.Add({
	name = "amd65.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/amd65/magin2.mp3")
})

sound.Add({
	name = "amd65.BoltPull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/amd65/boltpull.mp3")
})

sound.Add({
	name = "amd65.BoltBack",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/amd65/boltrelease.mp3")
})

sound.Add({
	name = "Wep_imitavor.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/tavor/famas-1.wav")
})

sound.Add({
	name = "Wep_imitavor.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tavor/famas_clipout.mp3")
})

sound.Add({
	name = "Wep_imitavor.Clipout1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tavor/famas_clipout1.mp3")
})

sound.Add({
	name = "Wep_imitavor.Tap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tavor/famas_tap.mp3")
})

sound.Add({
	name = "Wep_imitavor.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tavor/famas_clipin.mp3")
})

sound.Add({
	name = "Wep_imitavor.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tavor/famas_boltpull.mp3")
})

sound.Add({
	name = "Wep_imitavor.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tavor/famas_boltrelease.mp3")
})

sound.Add({
	name = "Wep_imitavor.Cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tavor/famas_cloth.mp3")
})

sound.Add({
	name = "Weapon_F2000.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/fokku_tc_f2000/shot-1.wav"),Sound("weapons/fokku_tc_f2000/shot-2.wav"),Sound("weapons/fokku_tc_f2000/shot-3.wav"),Sound("weapons/fokku_tc_f2000/shot-4.wav")}	
})

sound.Add({
	name = "f2000.playerbreathing",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_f2000/playerbreathing.mp3")	
})

sound.Add({
	name = "f2000.lightcloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_f2000/cloth2.mp3")	
})

sound.Add({
	name = "f2000.heavycloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_f2000/cloth.mp3")	
})

sound.Add({
	name = "f2000.magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_f2000/clipout.mp3")	
})

sound.Add({
	name = "f2000.magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_f2000/clipin.mp3")	
})

sound.Add({
	name = "f2000.boltback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {Sound("weapons/fokku_tc_f2000/chargeback.mp3"),Sound("weapons/fokku_tc_f2000/chargeback1.mp3")}	
})

sound.Add({
	name = "f2000.boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {Sound("weapons/fokku_tc_f2000/chargefor.mp3"),Sound("weapons/fokku_tc_f2000/chargefor1.mp3")}	
})

sound.Add({
	name = "47ak.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/AYKAYFORTY/ak47-1.wav")
})

sound.Add({
	name = "47ak.Bolt",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/AYKAYFORTY/bolt.mp3")
})

sound.Add({
	name = "47ak.magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/AYKAYFORTY/magin.mp3")
})

sound.Add({
	name = "47ak.magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/AYKAYFORTY/magout.mp3")
})

sound.Add({
	name = "Weapon_M14SP.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/fokku_tc_m14/sg550-1.wav")
})

sound.Add({
	name = "Weapon_M14SP.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_m14/sg550_clipout.mp3")
})

sound.Add({
	name = "Weapon_M14SP.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_m14/sg550_clipin.mp3")
})

sound.Add({
	name = "Weapon_M14SP.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_m14/sg550_boltpull.mp3")
})

sound.Add({
	name = "Weapon_M14.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_m14/sg550_deploy.mp3")
})

sound.Add({
	name = "G36.single",
	channel = CHAN_USER_BASE+10,
	volume = 0.75,
	sound = Sound("weapons/G36/m4a1_unsil-1.wav")
})

sound.Add({
	name = "G36.SilencedSingle",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1-1.wav")
})

sound.Add({
	name = "G36.Boltback",
	channel = CHAN_STATIC,
	volume = 0.5,
	sound = Sound("weapons/G36/Boltback.mp3")
})

sound.Add({
	name = "G36.BoltPull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/BoltPull.mp3")
})

sound.Add({
	name = "G36.PocketRussle",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/PocketRussle.mp3")
})

sound.Add({
	name = "G36.MagOut",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/MagOut.mp3")
})

sound.Add({
	name = "G36.MagFiddle",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/MagFiddle.mp3")
})

sound.Add({
	name = "G36.MagSlap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/MagSlap.mp3")
})

sound.Add({
	name = "G36.PlaceSilencer",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/PlaceSilencer.mp3")
})

sound.Add({
	name = "G36.TightenSilencer",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/TightenSilencer.mp3")
})

sound.Add({
	name = "G36.SpinSilencer",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/SpinSilencer.mp3")
})

sound.Add({
	name = "G36.Safety",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/G36/Safety.mp3")
})

sound.Add({
	name = "Weapon_73.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/winchester73/w73-1.wav")	
})

sound.Add({
	name = "Weapon_73.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/winchester73/w73pump.mp3")
})

sound.Add({
	name = "Weapon_73.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/winchester73/w73insertshell.mp3")
})

sound.Add({
	name = "Weapon_l85.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/L85A2/aug-1.wav")
})

sound.Add({
	name = "Weapon_l85.magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/L85A2/magin.mp3")
})

sound.Add({
	name = "Weapon_l85.magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/L85A2/magout.mp3")
})

sound.Add({
	name = "Weapon_l85.boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/L85A2/boltslap.mp3")
})

sound.Add({
	name = "Weapon_l85.boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/L85A2/boltpull.mp3")
})

sound.Add({
	name = "Weapon_l85.cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/L85A2/cloth.mp3")
})

sound.Add({
	name = "Weapon_l85.Tap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/L85A2/tap.mp3")
})	

sound.Add({
	name = "aug_a3.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/auga3/aug-1.wav"),Sound("weapons/auga3/aug-2.wav")}
})

sound.Add({
	name = "Weap_auga3.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/auga3/clipout.mp3")
})

sound.Add({
	name = "Weap_auga3.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/auga3/clipin.mp3")
})

sound.Add({
	name = "Weap_auga3.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/auga3/boltpull.mp3")
})

sound.Add({
	name = "Weap_auga3.boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/auga3/boltslap.mp3")
})

sound.Add({
	name = "Weapon_FAMTC.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/fokku_tc_famas/shot-1.wav"),Sound("weapons/fokku_tc_famas/shot-2.wav")}
})

sound.Add({
	name = "Weapon_FAMTC.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_famas/famas_clipout.mp3")
})

sound.Add({
	name = "Weapon_FAMTC.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_famas/famas_clipin.mp3")
})

sound.Add({
	name = "Weapon_FAMTC.forearm",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_famas/famas_forearm.mp3")
})

sound.Add({
	name = "Dmgfok_vally.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dmg_val/galil-1.wav")
})

sound.Add({
	name = "Dmgfok_vally.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_val/galil_clipout.mp3")
})

sound.Add({
	name = "Dmgfok_vally.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_val/galil_clipin.mp3")
})

sound.Add({
	name = "Dmgfok_vally.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_val/galil_Boltpull.mp3")
})

sound.Add({
	name = "Dmgfok_vally.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_val/draw.mp3")
})

sound.Add({
	name = "Dmgfok_vikhr.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dmg_vikhr/galil-1.wav")
})

sound.Add({
	name = "Dmgfok_vikhr.Silenced",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_vikhr/galil-sil.mp3")
})

sound.Add({
	name = "Dmgfok_vikhr.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_vikhr/galil_clipout.mp3")
})

sound.Add({
	name = "Dmgfok_vikhr.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_vikhr/galil_clipin.mp3")
})

sound.Add({
	name = "Dmgfok_vikhr.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_vikhr/galil_Boltpull.mp3")
})

sound.Add({
	name = "Dmgfok_vikhr.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_vikhr/draw.mp3")
})

sound.Add({
	name = "Masada.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound(")weapons/masadamagpul/masada_unsil.wav")	
})

sound.Add({
	name = "Masada.Cloth1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/cloth1.mp3")
})

sound.Add({
	name = "Masada.Cloth2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/cloth2.mp3")
})

sound.Add({
	name = "Masada.Magin1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/magin1.mp3")	
})

sound.Add({
	name = "Masada.Magin2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/magin2.mp3")
})

sound.Add({
	name = "Masada.Foley",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/foley.mp3")
})

sound.Add({
	name = "Masada.Magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/magout.mp3")
})

sound.Add({
	name = "Masada.Magslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/magslap.mp3")
})

sound.Add({
	name = "Masada.Safety",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/safety.mp3")
})

sound.Add({
	name = "Masada.Chargerback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/chargerback.mp3")	
})

sound.Add({
	name = "Masada.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/masadamagpul/boltrelease.mp3")	
})

sound.Add({
	name = "Dmgfok_M4A1.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_unsil-1.wav")
})

sound.Add({
	name = "Dmgfok_M4A1.Silencer_Off",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_silencer_off.mp3")
})

sound.Add({
	name = "Dmgfok_M4A1.Silencer_On",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_silencer_on.mp3")
})

sound.Add({
	name = "Dmgfok_M4A1.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_clipout.mp3")
})

sound.Add({
	name = "Dmgfok_M4A1.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_clipin.mp3")
})

sound.Add({
	name = "Dmgfok_M4A1.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_boltrelease.mp3")
})

sound.Add({
	name = "Dmgfok_M4A1.Boltrelease2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_boltrelease_Silenced.mp3")
})

sound.Add({
	name = "Dmgfok_M4A1.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m4a1/m4a1_boltpull.mp3")
})

sound.Add({
	name = "Dmgfok_M16A4.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound(")weapons/dmg_m16a4/shoot.wav")
})

sound.Add({
	name = "Dmgfok_M16A4.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m16a4/magout.mp3")
})

sound.Add({
	name = "Dmgfok_M16A4.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m16a4/magin.mp3")
})

sound.Add({
	name = "Dmgfok_M16A4.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m16a4/boltrelease.mp3")
})

sound.Add({
	name = "Dmgfok_M16A4.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m16a4/boltpull.mp3")
})

sound.Add({
	name = "Tactic_AK47.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/fokku_tc_ak47/ak47-1.wav")
})

sound.Add({
	name = "Tactic_AK47.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_ak47/ak47_clipout.mp3")
})

sound.Add({
	name = "Tactic_AK47.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_ak47/ak47_clipin.mp3")
})

sound.Add({
	name = "Tactic_AK47.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_ak47/ak47_boltpull.mp3")
})

sound.Add({
	name = "Wep_fnscarh.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/fnscarh/aug-1.wav"),Sound("weapons/fnscarh/aug-2.wav"),Sound("weapons/fnscarh/aug-3.wav")}
})

sound.Add({
	name = "Wep_fnscar.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fnscarh/aug_boltpull.mp3")
})

sound.Add({
	name = "Wep_fnscar.Boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fnscarh/aug_boltslap.mp3")
})

sound.Add({
	name = "Wep_fnscar.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fnscarh/aug_clipout.mp3")
})

sound.Add({
	name = "Wep_fnscar.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fnscarh/aug_clipin.mp3")
})

sound.Add({
	name = "fnfal.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/fn_fal/galil-1.wav")
})

sound.Add({
	name = "Weapon_fnfal.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fn_fal/galil_clipout.mp3")
})

sound.Add({
	name = "Weapon_fnfal.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fn_fal/galil_clipin.mp3")
})

sound.Add({
	name = "Weapon_fnfal.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fn_fal/galil_boltpull.mp3")
})

sound.Add({
	name = "hk416weapon.SilencedSingle",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1-1.wav")
})

sound.Add({
	name = "hk416weapon.UnsilSingle",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_unsil-1.wav")
})

sound.Add({
	name = "hk416weapon.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_clipout.mp3")	
})

sound.Add({
	name = "hk416weapon.Magtap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_tap.mp3")	
})

sound.Add({
	name = "hk416weapon.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_clipin.mp3")	
})

sound.Add({
	name = "hk416weapon.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_boltpull.mp3")	
})

sound.Add({
	name = "hk416weapon.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_boltrelease.mp3")	
})

sound.Add({
	name = "hk416weapon.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_deploy.mp3")	
})

sound.Add({
	name = "hk416weapon.Silencer_On",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_silencer_on.mp3")	
})

sound.Add({
	name = "hk416weapon.Silencer_Off",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/twinkie_hk416/m4a1_silencer_off.mp3")	
})

sound.Add({
	name = "hk_g3_weapon.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/hk_g3/galil-1.wav")
})

sound.Add({
	name = "hk_g3_weapon.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_g3/galil_clipout.mp3")	
})

sound.Add({
	name = "hk_g3_weapon.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_g3/galil_clipin.mp3")	
})

sound.Add({
	name = "hk_g3_weapon.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_g3/boltpull.mp3")	
})

sound.Add({
	name = "hk_g3_weapon.Boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_g3/boltforward.mp3")	
})

sound.Add({
	name = "hk_g3_weapon.cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_g3/Cloth.mp3")	
})

sound.Add({
	name = "hk_g3_weapon.draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_g3/draw.mp3")	
})

sound.Add({
	name = "Weapon_AUG.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2aug/aug-1.wav")
})

sound.Add({
	name = "2eapon_AUG.Forearm",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2aug/aug_forearm.mp3")
})

sound.Add({
	name = "2eapon_AUG.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2aug/aug_boltpull.mp3")
})

sound.Add({
	name = "2eapon_AUG.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2aug/aug_clipout.mp3")
})

sound.Add({
	name = "2eapon_AUG.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2aug/aug_clipin.mp3")
})

sound.Add({
	name = "2eapon_AUG.Boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2aug/aug_boltslap.mp3")
})

sound.Add({
	name = "Weapon_Galil.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2galil/galil-1.wav")
})

sound.Add({
	name = "2eapon_Galil.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2galil/magout.mp3")
})

sound.Add({
	name = "2eapon_Galil.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2galil/magin.mp3")
})

sound.Add({
	name = "2eapon_Galil.cliptap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2galil/tap.mp3")
})

sound.Add({
	name = "2eapon_Galil.boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2galil/boltpull.mp3")
})

sound.Add({
	name = "2eapon_Galil.boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2galil/boltrel.mp3")
})

sound.Add({
	name = "Weapon_SG552.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2sg552/sg552-1.wav")
})

sound.Add({
	name = "2eapon_SG552.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2sg552/sg552_clipout.mp3")
})

sound.Add({
	name = "2eapon_SG552.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2sg552/sg552_clipin.mp3")
})

sound.Add({
	name = "2eapon_SG552.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2sg552/sg552_boltpull.mp3")
})

sound.Add({
	name = "2eapon_SG552.Stockfold",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2sg552/stockfold.mp3")
})

print("[MG] Included assault rilfe icons & sounds.")