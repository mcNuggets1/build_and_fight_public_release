if CLIENT then
	local icol = Color(255, 255, 255, 255) 
	killicon.Add("m9k_bizonp19", "vgui/hud/m9k_bizonp19", icol)
	killicon.Add("m9k_colt1911", "vgui/hud/m9k_colt1911", icol)
	killicon.Add("m9k_coltpython", "vgui/hud/m9k_coltpython", icol)
	killicon.Add("m9k_deagle", "vgui/hud/m9k_deagle", icol)
	killicon.Add("m9k_glock", "vgui/hud/m9k_glock", icol)
	killicon.Add("m9k_hk45", "vgui/hud/m9k_hk45", icol)
	killicon.Add("m9k_luger", "vgui/hud/m9k_luger", icol)
	killicon.Add("m9k_m29satan", "vgui/hud/m9k_m29satan", icol)
	killicon.Add("m9k_m92beretta", "vgui/hud/m9k_m92beretta", icol)
	killicon.Add("m9k_model3russian", "vgui/hud/m9k_model3russian", icol)
	killicon.Add("m9k_mp7", "vgui/hud/m9k_mp7", icol)
	killicon.Add("m9k_ragingbull", "vgui/hud/m9k_ragingbull", icol)
	killicon.Add("m9k_remington1858", "vgui/hud/m9k_remington1858", icol)
	killicon.Add("m9k_sig_p229r", "vgui/hud/m9k_sig_p229r", icol)
	killicon.Add("m9k_smgp90", "vgui/hud/m9k_smgp90", icol)
	killicon.Add("m9k_sten", "vgui/hud/m9k_sten", icol)
	killicon.Add("m9k_thompson", "vgui/hud/m9k_thompson", icol)
	killicon.Add("m9k_usp", "vgui/hud/m9k_usp", icol)
	killicon.Add("m9k_uzi", "vgui/hud/m9k_uzi", icol)
	killicon.Add("m9k_model500", "vgui/hud/m9k_model500", icol)
	killicon.Add("m9k_model627", "vgui/hud/m9k_model627", icol)
	killicon.Add("m9k_ump45", "vgui/hud/m9k_ump45", icol)
	killicon.Add("m9k_mp9", "vgui/hud/m9k_mp9", icol)
	killicon.Add("m9k_vector", "vgui/hud/m9k_vector", icol)
	killicon.Add("m9k_tec9", "vgui/hud/m9k_tec9", icol)
	killicon.Add("m9k_mp5", "vgui/hud/m9k_mp5", icol)
	killicon.Add("m9k_kac_pdw", "vgui/hud/m9k_kac_pdw", icol)
	killicon.Add("m9k_honeybadger", "vgui/hud/m9k_honeybadger", icol)
	killicon.Add("m9k_mp5sd", "vgui/hud/m9k_mp5sd", icol)
	killicon.Add("m9k_magpulpdr", "vgui/hud/m9k_magpulpdr", icol)
	killicon.Add("m9k_scoped_taurus", "vgui/hud/m9k_scoped_taurus", icol)
	killicon.Add("m9k_mp40", "vgui/hud/m9k_mp40", icol)

	killicon.Add("m9k_fiveseven", "vgui/hud/m9k_fiveseven", icol)
	killicon.Add("m9k_p228", "vgui/hud/m9k_p228", icol)
	killicon.Add("m9k_tmp", "vgui/hud/m9k_tmp", icol)
end

sound.Add({
	name = "mp40.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/mp40/mp5-1.wav")
})

sound.Add({
	name = "Weapon_mp40m9k.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp40/magout.mp3")
})

sound.Add({
	name = "Weapon_mp40m9k.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp40/magin.mp3")
})

sound.Add({
	name = "Weapon_mp40m9k.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp40/boltback.mp3")
})

sound.Add({
	name = "MAG_PDR.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/pdr/pdr-1.wav"), Sound("weapons/pdr/pdr-2.wav"), Sound("weapons/pdr/pdr-3.wav")}
})

sound.Add({
	name = "Weapon_PDR.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pdr/pdr_clipin.mp3")
})

sound.Add({
	name = "Weapon_PDR.Clipin2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pdr/pdr_clipin2.mp3")
})

sound.Add({
	name = "Weapon_PDR.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pdr/pdr_boltpull.mp3")
})

sound.Add({
	name = "Weapon_PDR.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pdr/pdr_boltrelease.mp3")
})

sound.Add({
	name = "Weapon_PDR.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pdr/pdr_clipout.mp3")
})

sound.Add({
	name = "KAC_PDW.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1_unsil-1.wav")
})

sound.Add({
	name = "KAC_PDW.SilentSingle",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1-1.wav")
})

sound.Add({
	name = "kac_pdw_001.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1_clipout.mp3")
})

sound.Add({
	name = "kac_pdw_001.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1_clipin.mp3")
})

sound.Add({
	name = "kac_pdw_001.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1_boltpull.mp3")
})

sound.Add({
	name = "kac_pdw_001.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1_deploy.mp3")
})

sound.Add({
	name = "kac_pdw_001.Silencer_On",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1_silencer_on.mp3")
})

sound.Add({
	name = "kac_pdw_001.Silencer_Off",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/kac_pdw/m4a1_silencer_off.mp3")
})

sound.Add({
	name = "mp5_navy_Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/brightmp5/mp5-1.wav")
})

sound.Add({
	name = "mp5_foley",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/foley.mp3")
})

sound.Add({
	name = "mp5_magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/magout.mp3")
})

sound.Add({
	name = "mp5_magin1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/magin1.mp3")
})

sound.Add({
	name = "mp5_magin2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/magin2.mp3")
})

sound.Add({
	name = "mp5_boltback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/boltback.mp3")
})

sound.Add({
	name = "mp5_boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/boltslap.mp3")
})

sound.Add({
	name = "mp5_cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/cloth.mp3")
})

sound.Add({
	name = "mp5_safety",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/brightmp5/safety.mp3")
})

sound.Add({
	name = "Weapon_Tec9.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/tec9/ump45-1.wav")
})

sound.Add({
	name = "Weapon_Tec9.Magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tec9/tec9_magin.mp3")
})

sound.Add({
	name = "Weapon_Tec9.Magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tec9/tec9_magout.mp3")
})

sound.Add({
	name = "Weapon_Tec9.NewMag",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tec9/tec9_newmag.mp3")
})

sound.Add({
	name = "Weapon_Tec9.Charge",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tec9/tec9_charge.mp3")
})

sound.Add({
	name = "kriss_vector.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/Kriss/ump45-1.wav")
})

sound.Add({
	name = "kriss_vector.Magrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/Kriss/magrel.mp3")
})

sound.Add({
	name = "kriss_vector.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/Kriss/clipout.mp3")
})

sound.Add({
	name = "kriss_vector.Dropclip",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/Kriss/dropclip.mp3")
})

sound.Add({
	name = "kriss_vector.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/Kriss/clipin.mp3")
})


sound.Add({
	name = "kriss_vector.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/Kriss/boltpull.mp3")
})

sound.Add({
	name = "kriss_vector.unfold",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/Kriss/unfold.mp3")
})

sound.Add({
	name = "Weapon_mp9.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/mp9/tmp-1.wav")
})

sound.Add({
	name = "Weapon_mp9.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp9/tmp_clipin.mp3")
})

sound.Add({
	name = "Weapon_mp9.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp9/tmp_clipout.mp3")
})

sound.Add({
	name = "m9k_hk_ump45.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/hk_ump45/ump45-1.wav")
})

sound.Add({
	name = "m9k_hk_ump45.Clipout1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_ump45/ump45_clipout1.mp3")
})

sound.Add({
	name = "m9k_hk_ump45.Clipout2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_ump45/ump45_clipout2.mp3")
})

sound.Add({
	name = "m9k_hk_ump45.Clipin1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_ump45/ump45_clipin1.mp3")
})

sound.Add({
	name = "m9k_hk_ump45.Clipin2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_ump45/ump45_clipin2.mp3")
})

sound.Add({
	name = "m9k_hk_ump45.Boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_ump45/ump45_boltslap.mp3")
})

sound.Add({
	name = "m9k_hk_ump45.Cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk_ump45/ump45_cloth.mp3")
})

sound.Add({
	name = "Weapon_P19.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/p19/p90-1.wav")
})

sound.Add({
	name = "Weapon_P19.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/p19/p90_clipout.mp3")
})

sound.Add({
	name = "Weapon_P19.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/p19/p90_clipin.mp3")
})

sound.Add({
	name = "Weapon_P19.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/p19/p90_boltpull.mp3")
})

sound.Add({
	name = "P90_weapon.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/p90_smg/p90-1.wav")
})

sound.Add({
	name = "P90_weapon.unlock",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/p90_smg/p90_unlock.mp3")
})

sound.Add({
	name = "P90_weapon.magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/p90_smg/p90_magout.mp3")
})

sound.Add({
	name = "P90_weapon.magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/p90_smg/p90_magin.mp3")
})

sound.Add({
	name = "P90_weapon.cock",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/p90_smg/p90_cock.mp3")
})

sound.Add({
	name = "Weaponsten.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/sten/mp5-1.wav")
})

sound.Add({
	name = "Weaponsten.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sten/mp5_clipout.mp3")
	
})

sound.Add({
	name = "Weaponsten.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sten/mp5_clipin.mp3")
})

sound.Add({
	name = "Weaponsten.boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sten/mp5_boltpull.mp3")	
})

sound.Add({
	name = "Weaponsten.boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sten/mp5_boltslap.mp3")
})

sound.Add({
	name = "Weapon_stengun.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sten/mp5_slideback.mp3")
})

sound.Add({
	name = "Weapon_tmg.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/tmg/tmg_1.wav")
})

sound.Add({
	name = "Weapon_tmg.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tmg/tmg_magout.mp3")
})

sound.Add({
	name = "Weapon_tmg.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tmg/tmg_magin.mp3")
})

sound.Add({
	name = "Weapon_tmg.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tmg/tmg_cock.mp3")
})

sound.Add({
	name = "Weapon_MP7.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/mp7/usp1.wav")
})

sound.Add({
	name = "Weapon_MP7.magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp7/mp7_magout.mp3")
})

sound.Add({
	name = "Weapon_MP7.magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp7/mp7_magin.mp3")
})

sound.Add({
	name = "Weapon_MP7.charger",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/mp7/mp7_charger.mp3")
})

sound.Add({
	name = "Weapon_uzi.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/uzi/mac10-1.wav")
})

sound.Add({
	name = "imi_uzi_09mm.boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/uzi/mac10_boltpull.mp3")
})

sound.Add({
	name = "imi_uzi_09mm.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/uzi/mac10_clipin.mp3")
})

sound.Add({
	name = "imi_uzi_09mm.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/uzi/mac10_clipout.mp3")
})

sound.Add({
	name = "Weapon_hkmp5sd.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/mp5-1.wav")
})

sound.Add({
	name = "Weapon_hkmp5sd.magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/magout.mp3")
})

sound.Add({
	name = "Weapon_hkmp5sd.magfiddle",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/magfiddle.mp3")
})

sound.Add({
	name = "Weapon_hkmp5sd.magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/magin.mp3")
})

sound.Add({
	name = "Weapon_hkmp5sd.boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/boltpull.mp3")
})

sound.Add({
	name = "Weapon_hkmp5sd.boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/boltrelease.mp3")
})

sound.Add({
	name = "Weapon_hkmp5sd.cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/cloth.mp3")
})

sound.Add({
	name = "Weapon_hkmp5sd.safety",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hkmp5sd/safety.mp3")
})

sound.Add({
	name = "Weapon_HoneyB.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/hb/hb_fire.wav")
})

sound.Add({
	name = "Weapon_HoneyB.Magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hb/magout.mp3")
})

sound.Add({
	name = "Weapon_HoneyB.Magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hb/magin.mp3")
})

sound.Add({
	name = "Weapon_HoneyB.Boltcatch",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hb/boltcatch.mp3")
})

sound.Add({
	name = "Weapon_HoneyB.Boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hb/boltforward.mp3")
})

sound.Add({
	name = "Weapon_HoneyB.Boltback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hb/boltback.mp3")
})

sound.Add({
	name = "Weapon_ColtPython.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/coltpython/python-1.wav")
})

sound.Add({
	name = "WepColtPython.clipdraw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/coltpython/clipdraw.mp3")
})

sound.Add({
	name = "WepColtPython.blick",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/coltpython/blick.mp3")
})

sound.Add({
	name = "WepColtPython.bulletsout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/coltpython/bulletsout.mp3")
})

sound.Add({
	name = "WepColtPython.bulletsin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/coltpython/bulletsin.mp3")
})

sound.Add({
	name = "weapon_r_bull.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/r_bull/r-bull-1.wav")
})

sound.Add({
	name = "weapons_r_bull_bullreload_wav",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/r_bull/bullreload.mp3")
})

sound.Add({
	name = "weapons_r_bull_draw_gun_wav",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/r_bull/draw_gun.mp3")
})

sound.Add({
	name = "Model3.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/model3/model3-1.wav")
})

sound.Add({
	name = "Model3.Hammer",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model3/Hammer.mp3")
})

sound.Add({
	name = "Model3.Break_Eject",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model3/Break_eject.mp3")
})

sound.Add({
	name = "Model3.bulletout_1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model3/bulletout_1.mp3")
})

sound.Add({
	name = "Model3.bulletout_2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model3/bulletout_2.mp3")
})

sound.Add({
	name = "Model3.bulletout_3",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model3/bulletout_3.mp3")
})

sound.Add({
	name = "Model3.bullets_in",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model3/bullets_in.mp3")
})

sound.Add({
	name = "Model3.Break_close",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model3/Break_CLose.mp3")	
})

sound.Add({
	name = "Weapon_satan1.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/satan1/satan-1.wav")
})

sound.Add({
	name = "Weapon_satan1.blick",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/satan1/blick.mp3")
})

sound.Add({
	name = "Weapon_satan1.unfold",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/satan1/unfold.mp3")
})

sound.Add({
	name = "Weapon_satan1.bulletsin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/satan1/bulletsin.mp3")
})

sound.Add({
	name = "Weapon_satan1.bulletsout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/satan1/bulletsout.mp3")
})

sound.Add({
	name = "Remington.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/remington/remington-1.wav")
})

sound.Add({
	name = "Remington.cylinderhit",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/remington/cylinderhit.mp3")
})

sound.Add({
	name = "Remington.cylinderswap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/remington/cylinderswap.mp3")
})

sound.Add({
	name = "Remington.bounce1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/remington/bounce1.mp3")
})

sound.Add({
	name = "Remington.bounce1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/remington/bounce2.mp3")
})

sound.Add({
	name = "Remington.bounce1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/remington/bounce3.mp3")
})

sound.Add({
	name = "Remington.Hammer",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/remington/hammer.mp3")
})

sound.Add({
	name = "Weapon_m92b.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound(")weapons/beretta92/berettam92-1.wav")
})

sound.Add({
	name = "Weapon_beretta92.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/beretta92/berettam92_clipout.mp3")
})

sound.Add({
	name = "Weapon_beretta92.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/beretta92/berettam92_clipin.mp3")
})

sound.Add({
	name = "Weapon_beretta92.Sliderelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/beretta92/berettam92_sliderelease.mp3")
})

sound.Add({
	name = "Weapon_beretta92.Slidepull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/beretta92/berettam92_slidepull.mp3")
})

sound.Add({
	name = "Weapon_beretta92.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/beretta92/berettam92_slideback.mp3")
})

sound.Add({
	name = "Weapon_hk45.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/hk45/hk45-1.wav")
})

sound.Add({
	name = "HK45C.Deploy",
	channel = CHAN_STATIC,
	volume = 1,	
	sound = Sound("weapons/hk45/draw.mp3")
})

sound.Add({
	name = "HK45C.Magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk45/magout.mp3")
})

sound.Add({
	name = "HK45C.Magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk45/magin.mp3")
})

sound.Add({
	name = "HK45C.Release",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk45/sliderelease.mp3")
})

sound.Add({
	name = "HK45C.Slidepull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hk45/slidepull.mp3")
})

sound.Add({
	name = "Weapon_fokkususp.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/fokku_tc_usp/fiveseven-1.wav")
})

sound.Add({
	name = "Weapon_fokkususp.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_usp/fiveseven_clipout.mp3")
})

sound.Add({
	name = "Weapon_fokkususp.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_usp/fiveseven_clipin.mp3")
})

sound.Add({
	name = "Weapon_fokkususp.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_usp/fiveseven_slideback.mp3")
})

sound.Add({
	name = "Weapon_fokkususp.Slidepull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_usp/fiveseven_slidepull.mp3")
})

sound.Add({
	name = "Sauer1_P228.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/sig_p228/p228-1.wav")
})

sound.Add({
	name = "Sauer1_P228.Magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sig_p228/magout.mp3")
})

sound.Add({
	name = "Sauer1_P228.Magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sig_p228/magin.mp3")
})

sound.Add({
	name = "Sauer1_P228.MagShove",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sig_p228/magshove.mp3")
})

sound.Add({
	name = "Sauer1_P228.Sliderelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sig_p228/sliderelease.mp3")
})

sound.Add({
	name = "Sauer1_P228.Cloth",
	channel = CHAN_STATIC,
	volume = 1.5,
	sound = Sound("weapons/sig_p228/cloth.mp3")
})

sound.Add({
	name = "Sauer1_P228.Shift",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/sig_p228/shift.mp3")
})

sound.Add({
	name = "Dmgfok_glock.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dmg_glock/mac10-1.wav")
})

sound.Add({
	name = "Dmgfok_glock.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_glock/magout.mp3")
})

sound.Add({
	name = "Dmgfok_glock.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_glock/magin.mp3")
})

sound.Add({
	name = "Dmgfok_glock.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_glock/boltpull.mp3")
})

sound.Add({
	name = "Dmgfok_glock.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_glock/boltrelease.mp3")
})

sound.Add({
	name = "Dmgfok_glock.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_glock/mac10_deploy.mp3")
})

sound.Add({
	name = "Dmgfok_co1911.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dmg_colt1911/deagle-1.wav")
})

sound.Add({
	name = "Dmgfok_co1911.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_colt1911/draw.mp3")
})

sound.Add({
	name = "Dmgfok_co1911.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_colt1911/de_clipin.mp3")
})

sound.Add({
	name = "Dmgfok_co1911.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_colt1911/de_slideback.mp3")
})

sound.Add({
	name = "Dmgfok_co1911.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_colt1911/draw.mp3")
})

sound.Add({
	name = "Weapon_luger.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/luger/luger-1.wav")
})

sound.Add({
	name = "Weapon_luger.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/luger/luger_clipout.mp3")
})

sound.Add({
	name = "Weapon_luger.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/luger/luger_clipin.mp3")
})

sound.Add({
	name = "Weapon_luger.Sliderelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/luger/luger_sliderelease.mp3")
})

sound.Add({
	name = "Weapon_TDegle.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/fokku_tc_deagle/deagle-1.wav")
})

sound.Add({
	name = "Weapon_TDegle.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_deagle/de_clipout.mp3")
})

sound.Add({
	name = "Weapon_TDegle.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_deagle/de_clipin.mp3")
})

sound.Add({
	name = "Weapon_TDegle.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_deagle/de_slideback.mp3")
})

sound.Add({
	name = "Weapon_TDegle.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_deagle/de_deploy.mp3")
})

sound.Add({
	name = "Sauer1_P228.Single",
	channel = CHAN_USER_BASE+10,
	volume =	1,
	sound = Sound("weapons/sig_p228/p228-1.wav")
})

sound.Add({
	name = "Sauer1_P228.Magout",
	channel = CHAN_STATIC,
	volume =	1,
	sound = Sound("weapons/sig_p228/magout.mp3")
})

sound.Add({
	name = "Sauer1_P228.Magin",
	channel = CHAN_STATIC,
	volume =	1,
	sound = Sound("weapons/sig_p228/magin.mp3")
})

sound.Add({
	name = "Sauer1_P228.MagShove",
	channel = CHAN_STATIC,
	volume =	1,
	sound = Sound("weapons/sig_p228/magshove.mp3")
})

sound.Add({
	name = "Sauer1_P228.Sliderelease",
	channel = CHAN_STATIC,
	volume =	1,
	sound = Sound("weapons/sig_p228/sliderelease.mp3")
})

sound.Add({
	name = "Sauer1_P228.Cloth",
	channel = CHAN_STATIC,
	volume =	.5,
	sound = Sound("weapons/sig_p228/cloth.mp3")
})

sound.Add({
	name = "Sauer1_P228.Shift",
	channel = CHAN_STATIC,
	volume =	1,
	sound = Sound("weapons/sig_p228/shift.mp3")
})

sound.Add({
	name = "Model_500.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/model500/deagle-1.wav")		
})

sound.Add({
	name = "saw_model_500.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model500/de_clipin.mp3")	
})

sound.Add({
	name = "saw_model_500.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model500/de_clipout.mp3")	
})

sound.Add({
	name = "saw_model_500.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model500/de_deploy.mp3")	
})

sound.Add({
	name = "saw_model_500.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/model500/de_slideback.mp3")	
})

sound.Add({
	name = "model_627perf.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/627/deagle-1.wav")
})

sound.Add({
	name = "model_627perf.wheel_in",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/627/wheel_in.mp3")
})

sound.Add({
	name = "model_627perf.bullets_in",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/627/bullets_in.mp3")
})

sound.Add({
	name = "model_627perf.bulletout_3",
	channel = CHAN_USER_BASE+11,
	volume = 1,
	sound = Sound("weapons/627/bulletout_3.mp3")
})

sound.Add({
	name = "model_627perf.bulletout_2",
	channel = CHAN_USER_BASE+12,
	volume = 1,
	sound = Sound("weapons/627/bulletout_2.mp3")
})

sound.Add({
	name = "model_627perf.bulletout_1",
	channel = CHAN_USER_BASE+13,
	volume = 1,
	sound = Sound("weapons/627/bulletout_1.mp3")
})

sound.Add({
	name = "model_627perf.wheel_out",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/627/wheel_out.mp3")
})

sound.Add({
	name = "Weapon_hkusc.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/usc/ump45-1.wav"), Sound("weapons/usc/ump45-2.wav")}
})

sound.Add({
	name = "Weapon_hkusc.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/usc/ump45_clipout.mp3")
})

sound.Add({
	name = "Weapon_hkusc.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/usc/ump45_clipin.mp3")
})

sound.Add({
	name = "Weapon_hkusc.Boltslap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/usc/ump45_boltslap.mp3")
})

sound.Add({
	name = "Weapon_FiveSeven.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2fiveseven/fiveseven-1.wav")
})

sound.Add({
	name = "2eapon_57.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2fiveseven/clipout.mp3")
})

sound.Add({
	name = "2eapon_57.clipin1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2fiveseven/clipin1.mp3")
})

sound.Add({
	name = "2eapon_57.clipin2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2fiveseven/clipin2.mp3")
})

sound.Add({
	name = "2eapon_57.SlideForward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2fiveseven/slideforward.mp3")
})

sound.Add({
	name = "2eapon_57.SlideBack",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2fiveseven/slideback.mp3")
})

sound.Add({
	name = "Weapon_P228.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2p228/p228-1.wav")
})

sound.Add({
	name = "2eapon_p228.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2p228/clipout.mp3")
})

sound.Add({
	name = "2eapon_p228.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2p228/clipin.mp3")
})

sound.Add({
	name = "2eapon_p228.sliderelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2p228/sliderelease.mp3")
})

sound.Add({
	name = "2eapon_p228.slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2p228/slideback.mp3")
})

sound.Add({
	name = "2eapon_p228.slideforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2p228/slideforward.mp3")
})

sound.Add({
	name = "Weapon_TMP.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2tmp/tmp-1.wav")
})

sound.Add({
	name = "2eapon_TMP.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2tmp/tmp_clipout.mp3")
})

sound.Add({
	name = "2eapon_TMP.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2tmp/tmp_clipin.mp3")
})

sound.Add({
	name = "2eapon_TMP.boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2tmp/tmp_boltpull.mp3")
})

sound.Add({
	name = "2eapon_TMP.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2tmp/cloth.mp3")
})

sound.Add({
	name = "Mac_Cloth",
	channel = CHAN_STATIC,
	volume = 1.0,
	sound = "weapons/UMac-10U/Mac_cloth.wav"
})

sound.Add({
	name = "Mac_Boltpull",
	channel = CHAN_STATIC,
	volume = 1.0,
	sound = "weapons/UMac-10U/mac_boltpull.wav"
})

sound.Add({
	name = "Mac_magin",
	channel = CHAN_STATIC,
	volume = 1.0,
	sound = "weapons/UMac-10U/mac_clipin.wav"
})

sound.Add({
	name = "Mac_magout",
	channel = CHAN_STATIC,
	volume = 1.0,
	sound = "weapons/UMac-10U/mac_clipout.wav"
})

sound.Add({
	name = "Mac_magoutcloth",
	channel = CHAN_STATIC,
	volume = 1.0,
	sound = "weapons/UMac-10U/mac_magoutcloth.wav"
})

print("[MG] Included small arms icons & sounds.")