if CLIENT then
	local icol = Color(255, 255, 255, 255) 
	killicon.Add("m9k_1887winchester", "vgui/hud/m9k_1887winchester", icol)
	killicon.Add("m9k_1897winchester", "vgui/hud/m9k_1897winchester", icol)
	killicon.Add("m9k_ares_shrike", "vgui/hud/m9k_ares_shrike", icol)
	killicon.Add("m9k_aw50", "vgui/hud/m9k_aw50", icol)
	killicon.Add("m9k_barret_m82", "vgui/hud/m9k_barret_m82", icol)
	killicon.Add("m9k_browningauto5", "vgui/hud/m9k_browningauto5", icol)
	killicon.Add("m9k_contender", "vgui/hud/m9k_contender", icol)
	killicon.Add("m9k_dbarrel", "vgui/hud/m9k_dbarrel", icol)
	killicon.Add("m9k_dragunov", "vgui/hud/m9k_dragunov", icol)
	killicon.Add("m9k_fg42", "vgui/hud/m9k_fg42", icol)
	killicon.Add("m9k_intervention", "vgui/hud/m9k_intervention", icol)
	killicon.Add("m9k_ithacam37", "vgui/hud/m9k_ithacam37", icol)
	killicon.Add("m9k_jackhammer", "vgui/hud/m9k_jackhammer", icol)
	killicon.Add("m9k_m3", "vgui/hud/m9k_m3", icol)
	killicon.Add("m9k_m24", "vgui/hud/m9k_m24", icol)
	killicon.Add("m9k_m60", "vgui/hud/m9k_m60", icol)
	killicon.Add("m9k_m98b", "vgui/hud/m9k_m98b", icol)
	killicon.Add("m9k_m249lmg", "vgui/hud/m9k_m249lmg", icol)
	killicon.Add("m9k_m1918bar", "vgui/hud/m9k_m1918bar", icol)
	killicon.Add("m9k_minigun", "vgui/hud/m9k_minigun", icol)
	killicon.Add("m9k_mossberg590", "vgui/hud/m9k_mossberg590", icol)
	killicon.Add("m9k_psg1", "vgui/hud/m9k_psg1", icol)
	killicon.Add("m9k_remington870", "vgui/hud/m9k_remington870", icol)
	killicon.Add("m9k_remington7615p", "vgui/hud/m9k_remington7615p", icol)
	killicon.Add("m9k_sl8", "vgui/hud/m9k_sl8", icol)
	killicon.Add("m9k_svu", "vgui/hud/m9k_svu", icol)
	killicon.Add("m9k_usas", "vgui/hud/m9k_usas", icol)
	killicon.Add("m9k_spas12", "vgui/hud/m9k_spas12", icol)
	killicon.Add("m9k_svt40", "vgui/hud/m9k_svt40", icol)
	killicon.Add("m9k_striker12", "vgui/hud/m9k_striker12", icol)
	killicon.Add("m9k_pkm", "vgui/hud/m9k_pkm", icol)

	killicon.Add("m9k_awp", "vgui/hud/m9k_awp", icol)
	killicon.Add("m9k_g3sg1", "vgui/hud/m9k_g3sg1", icol)
	killicon.Add("m9k_scout", "vgui/hud/m9k_scout", icol)
	killicon.Add("m9k_m3super", "vgui/hud/m9k_m3super", icol)
	killicon.Add("m9k_xm1014", "vgui/hud/m9k_xm1014", icol)
end

sound.Add({
	name = "pkm.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/pkm/pkm-1.wav"), Sound("weapons/pkm/pkm-2.wav"), Sound("weapons/pkm/pkm-3.wav"), Sound("weapons/pkm/pkm-4.wav"), Sound("weapons/pkm/pkm-5.wav")}
})

sound.Add({
	name = "Weapon_PKM.Cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_cloth.mp3")
})

sound.Add({
	name = "Weapon_PKM.Coverup",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_coverup.mp3")
})

sound.Add({
	name = "Weapon_PKM.Bullet",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_bullet.mp3")
})

sound.Add({
	name = "Weapon_PKM.Boxout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_boxout.mp3")
})

sound.Add({
	name = "Weapon_PKM.Boxin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_boxin.mp3")
})

sound.Add({
	name = "Weapon_PKM.Chain",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_chain.mp3")
})

sound.Add({
	name = "Weapon_PKM.Coverdown",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_coverdown.mp3")
})

sound.Add({
	name = "Weapon_PKM.Coversmack",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_coversmack.mp3")
})

sound.Add({
	name = "Weapon_PKM.Bolt",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_bolt.mp3")
})

sound.Add({
	name = "Weapon_PKM.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/pkm/pkm_draw.mp3")
})

sound.Add({
	name = "Weapon_SVT40.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1-1.wav")
})

sound.Add({
	name = "Weapon_SVT40.Cloth1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1_cloth1.mp3")
})

sound.Add({
	name = "Weapon_SVT40.Cloth2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1_cloth2.mp3")
})

sound.Add({
	name = "Weapon_SVT40.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1_clipout.mp3")
})

sound.Add({
	name = "Weapon_SVT40.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1_clipin.mp3")
})

sound.Add({
	name = "Weapon_SVT40.ClipTap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1_cliptap.mp3")
})

sound.Add({
	name = "Weapon_SVT40.SlideBack",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1_slide_b.mp3")
})

sound.Add({
	name = "Weapon_SVT40.SlideForward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svt40/g3sg1_slide_f.mp3")
})

sound.Add({
	name = "spas_12_shoty.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/spas_12/xm1014-1.wav")
})

sound.Add({
	name = "spas_12_shoty.insert",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/spas_12/xm_insert.mp3")
})

sound.Add({
	name = "spas_12_shoty.cock",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/spas_12/xm_cock.mp3")
})

sound.Add({
	name = "Weapon_usas.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/usas12/xm1014-1.wav")
})

sound.Add({
	name = "Weapon_usas.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/usas12/magin.mp3")
})

sound.Add({
	name = "Weapon_usas.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/usas12/magout.mp3")
})

sound.Add({
	name = "Weapon_usas.draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/usas12/draw.mp3")
})

sound.Add({
	name = "7615p_remington.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/7615p/scout_fire-1.wav")
})

sound.Add({
	name = "7615p_bob.pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/7615p/m3_pump.mp3")
})

sound.Add({
	name = "Weapon_7615P.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/7615p/sg550_clipout.mp3")
})

sound.Add({
	name = "Weapon_7615P.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/7615p/sg550_clipin.mp3")
})

sound.Add({
	name = "Weapon_SVU.Single",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svu/g3sg1-1.wav")
})

sound.Add({
	name = "Weapon_svuxx.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svu/g3sg1_clipin.mp3")
})

sound.Add({
	name = "Weapon_svuxx.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svu/g3sg1_clipout.mp3")
})

sound.Add({
	name = "Weapon_svuxx.Slide",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/svu/g3sg1_slide.mp3")
})

sound.Add({
	name = "Weapon_Win94.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/win94/scout_fire-1.wav")
})

sound.Add({
	name = "Weapon_Win94.Bolt",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/win94/scout_bolt.mp3")
})

sound.Add({
	name = Sound("weapons/hamburgpling.wav"),
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/win94/hamburgpling.mp3")
})

sound.Add({
	name = "Weapon_Win94.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/win94/scout_clipout.mp3")
})

sound.Add({
	name = "ShotStriker12.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/striker12/xm1014-1.wav")
})

sound.Add({
	name = "ShotStriker12.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/striker12/deploy.mp3")
})

sound.Add({
	name = "ShotStriker12.InsertShell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/striker12/m3_insertshell.mp3")
})

sound.Add({
	name = "Weaponaw50.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/aw50/awp_fire.wav")
})

sound.Add({
	name = "Weaponaw50.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/aw50/awp_magin.mp3")
})

sound.Add({
	name = "Weaponaw50.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/aw50/awp_magout.mp3")
})
	
sound.Add({
	name = "Weaponaw50.boltback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/aw50/m24_boltback.mp3")
})

sound.Add({
	name = "Weaponaw50.boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/aw50/m24_boltforward.mp3")
})

sound.Add({
	name = "Weapon_psg_1.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/psg1/g3sg1-1.wav")
})

sound.Add({
	name = "Weapon_psg_1.Back",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/psg1/psg_boltpull.mp3")
})

sound.Add({
	name = "Weapon_psg_1.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/psg1/psg_clipout.mp3")
})

sound.Add({
	name = "Weapon_psg_1.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/psg1/psg_clipin.mp3")
})

sound.Add({
	name = "Weapon_psg_1.Forward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/psg1/psg_boltrelease.mp3")

})

sound.Add({
	name = "Weapon_psg_1.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/psg1/deploy1.mp3")
})

sound.Add({
	name = "contender_g2.Single",
	channel = CHAN_USER_BASE+10,
	volumel = 1,
	sound = {Sound("weapons/g2contender/scout-1.wav"),Sound("weapons/g2contender/scout-2.wav"),Sound("weapons/g2contender/scout-3.wav")}
})

sound.Add({
	name = "contender_g2.Draw",
	channel = CHAN_STATIC,
	volumel = 1,
	sound = Sound("weapons/g2contender/Draw.mp3")
})


sound.Add({
	name = "contender_g2.Hammer",
	channel = CHAN_USER_BASE+1,
	volume = 1,
	sound = {Sound("weapons/g2contender/Cock-1.mp3"),Sound("weapons/g2contender/Cock-2.mp3")}
})

sound.Add({
	name = "contender_g2.Open",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/g2contender/open_chamber.mp3")
})

sound.Add({
	name = "contender_g2.Shellout",
	channel = CHAN_USER_BASE+1,
	volume = 1,
	sound = Sound("weapons/g2contender/Bullet_out.mp3")
})

sound.Add({
	name = "contender_g2.Shellin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/g2contender/Bullet_in.mp3")
})

sound.Add({
	name = "contender_g2.Close",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/g2contender/close_chamber.mp3")
})

sound.Add({
	name = "contender_g2.Shell",
	channel = CHAN_USER_BASE+2,
	volume = 1,
	sound = {Sound("weapons/g2contender/pl_shell1.mp3"),Sound("weapons/g2contender/pl_shell2.mp3"),Sound("weapons/g2contender/pl_shell3.mp3"),Sound("weapons/g2contender/pl_shell4.mp3")}
})

sound.Add({
	name = "M98.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/M98/shot-1.wav")
})

sound.Add({
	name = "M98_Bolt",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/bolt.mp3")
})


sound.Add({
	name = "M98_Handle",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/handle.mp3")
})

sound.Add({
	name = "M98_Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/draw.mp3")
})

sound.Add({
	name = "M98_Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/draw_2.mp3")
})

sound.Add({
	name = "M98_Foley",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/foley.mp3")
})

sound.Add({
	name = "M98_Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/clipout.mp3")
})

sound.Add({
	name = "M98_Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/clipin.mp3")
})

sound.Add({
	name = "M98_Boltback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/boltback.mp3")
})

sound.Add({
	name = "M98_Boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M98/boltforward.mp3")
})

sound.Add({
	name = "BarretM82.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/M82/barret50-1.wav")
})

sound.Add({
	name = "Weapon_M82.Boltup",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M82/boltup.mp3")
})

sound.Add({
	name = "Weapon_M82.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M82/clipin.mp3")
})

sound.Add({
	name = "Weapon_M82.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M82/clipout.mp3")
})

sound.Add({
	name = "Weapon_M82.Boltdown",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/M82/boltdown.mp3")
})

sound.Add({
	name = "Dmgfok_M24SN.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dmg_m24/awp1.wav")
})

sound.Add({
	name = "Dmgfok_M24SN.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m24/m24_magin.mp3")
})

sound.Add({
	name = "Dmgfok_M24SN.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m24/m24_magout.mp3")
})

sound.Add({
	name = "Dmgfok_M24SN.Boltback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m24/m24_boltback.mp3")
})

sound.Add({
	name = "Dmgfok_M24SN.Boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dmg_m24/m24_boltforward.mp3")
})

sound.Add({
	name = "Weapon_svd01.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/SVD/g3sg1-1.wav")
})

sound.Add({
	name = "Weapon_SVD.Foley",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/foley.mp3")	
})

sound.Add({
	name = "Weapon_SVD.Handle",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/handle.mp3")	
})

sound.Add({
	name = "Weapon_SVD.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/Clipout.mp3")
})

sound.Add({
	name = "Weapon_SVD.Cliptap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/Cliptap.mp3")
	
})

sound.Add({
	name = "Weapon_SVD.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/ClipIn.mp3")
	
})

sound.Add({
	name = "Weapon_SVD.Slideback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/SlideBack.mp3")
})

sound.Add({
	name = "Weapon_SVD.SlideForward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/SlideForward.mp3")	
})

sound.Add({
	name = "Weapon_SVD.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/SVD/Draw.mp3")
})

sound.Add({
	name = "Weapon_hksl8.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/hksl8/SG552-1.wav"),Sound("weapons/hksl8/SG552-2.wav"),Sound("weapons/hksl8/SG552-3.wav"),Sound("weapons/hksl8/SG552-4.wav")}
})

sound.Add({
	name = "sl8.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hksl8/draw.mp3")
})

sound.Add({
	name = "sl8.Safety",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hksl8/safety.mp3")
})

sound.Add({
	name = "sl8.Magout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hksl8/magout.mp3")
})

sound.Add({
	name = "sl8.MagFiddle",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hksl8/magfiddle.mp3")
})

sound.Add({
	name = "sl8.MagIn",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hksl8/magin.mp3")
})

sound.Add({
	name = "sl8.BoltBack",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hksl8/boltback.mp3")
})

sound.Add({
	name = "sl8.Boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/hksl8/boltforward.mp3")
})

sound.Add({
	name = "Weapon_INT.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/fokku_tc_intrv/int1.wav")
})

sound.Add({
	name = "Weapon_INT.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_intrv/int_deploy.mp3")
})

sound.Add({
	name = "Weapon_INT.Bolt",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_intrv/int_bolt.mp3")
})

sound.Add({
	name = "Weapon_INT.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_intrv/int_clipout.mp3")
})

sound.Add({
	name = "Weapon_INT.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fokku_tc_intrv/int_clipin.mp3")
})

sound.Add({
	name = "1887winch.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/1887winchester/1887-1.wav")
})

sound.Add({
	name = "1887winch.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/1887winchester/1887_insertshell.mp3")
})

sound.Add({
	name = "1887winch.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/1887winchester/1887pump1.mp3")
})

sound.Add({
	name = "1887pump2.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/1887winchester/1887pump2.mp3")
})

sound.Add({
	name = "Trench_97.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/1897trench/m3-1.wav")
})

sound.Add({
	name = "Trench_97.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/1897trench/m3_insertshell.mp3")
})

sound.Add({
	name = "Trench_97.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/1897trench/m3_pump.mp3")
})

sound.Add({
	name = "Trench_07.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/1897trench/1897_deploy.mp3")
})

sound.Add({
	name = "Weapon_a5.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/browninga5/xm1014-1.wav")
})

sound.Add({
	name = "Weapon_bauto5.InsertShell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/browninga5/xm1014_insertshell.mp3")
})

sound.Add({
	name = "Weapon_a5.back",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/browninga5/xm1014_check.mp3")
})

sound.Add({
	name = "Double_Barrel.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dbarrel/xm1014-1.wav")
})

sound.Add({
	name = "dbarrel_dblast",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/dbarrel/dblast.wav")
})

sound.Add({
	name = "Double_Barrel.InsertShell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dbarrel/xm1014_insertshell.mp3")
})

sound.Add({
	name = "Double_Barrel.barreldown",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dbarrel/barreldown.mp3")
})

sound.Add({
	name = "Double_Barrel.barrelup",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/dbarrel/barrelup.mp3")
})

sound.Add({
	name = "Weapon_Jackhammer.Single",
	channel = CHAN_USER_BASE+10,
	volume = 0.65,
	sound = Sound("weapons/jackhammer/xm1014-1.wav")
})

sound.Add({
	name = "Weapon_Jackhammer.Clipout",
	channel = CHAN_STATIC,
	volume = 0.65,
	sound = Sound("weapons/jackhammer/clipout.mp3")
})

sound.Add({
	name = "Weapon_Jackhammer.Clipin",
	channel = CHAN_STATIC,
	volume = 0.65,
	sound = Sound("weapons/jackhammer/magtap.mp3")
})

sound.Add({
	name = "Weapon_Jackhammer.Forearm",
	channel = CHAN_STATIC,
	volume = 0.45,
	sound = Sound("weapons/jackhammer/boltcatch.mp3")
})


sound.Add({
	name = "Weapon_Jackhammer.Cloth",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/jackhammer/cloth.mp3")
})

sound.Add({
	name = "IthacaM37.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/m37/m3-1.wav")
})

sound.Add({
	name = "IthacaM37.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m37/m3_insertshell.mp3")
})

sound.Add({
	name = "IthacaM37.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m37/m3_pump.mp3")
})

sound.Add({
	name = "Mberg_590.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/590/m3-1.wav")
})

sound.Add({
	name = "Mberg_590.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/590/m3_insertshell.mp3")
})

sound.Add({
	name = "Mberg_590.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/590/m3_pump.mp3")
})

sound.Add({
	name = "Mberg_590.Bullet",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/590/m3_bullet.mp3")
})

sound.Add({
	name = "Mberg_590.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/590/m3_draw.mp3")
})

sound.Add({
	name = "Weapon_shrk.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/shrike/shrike-1.wav")
})

sound.Add({
	name = "Weapon_shrk.bOut",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/boxout.mp3")
})

sound.Add({
	name = "Weapon_shrk.Button",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/button.mp3")
})

sound.Add({
	name = "Weapon_shrk.cUp",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/coverup.mp3")
})

sound.Add({
	name = "Weapon_shrk.Bullet1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/bullet.mp3")
})

sound.Add({
	name = "Weapon_shrk.bIn",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/boxin.mp3")
})

sound.Add({
	name = "Weapon_shrk.Bullet2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/bullet.mp3")
})

sound.Add({
	name = "Weapon_shrk.cDown",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/coverdown.mp3")
})

sound.Add({
	name = "Weapon_shrk.Ready",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/shrike/ready.mp3")
})

sound.Add({
	name = "Weapon_M_60.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound(")weapons/m60/m60-1.wav")
})

sound.Add({
	name = "Weapon_M_60.Coverup",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m60/m60_coverup.mp3")
})

sound.Add({
	name = "Weapon_M_60.Boxout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m60/m60_boxout.mp3")
})

sound.Add({
	name = "Weapon_M_60.Boxin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m60/m60_boxin.mp3")
})

sound.Add({
	name = "Weapon_M_60.Chain",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m60/m60_chain.mp3")
})

sound.Add({
	name = "Weapon_M_60.Coverdown",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m60/m60_coverdown.mp3")
})

sound.Add({
	name = "Weapon_249M.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/schmung.M249/m249-1.wav")
})

sound.Add({
	name = "Weapon_249M.Coverdown",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/schmung.M249/m249_coverdown.mp3")
})

sound.Add({
	name = "Weapon_249M.Chain",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/schmung.M249/m249_chain.mp3")
})

sound.Add({
	name = "Weapon_249M.Coverup",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/schmung.M249/m249_coverup.mp3")
})

sound.Add({
	name = "Weapon_249M.Boxout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/schmung.M249/m249_boxout.mp3")
})

sound.Add({
	name = "Weapon_Flakk249.Magin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/schmung.M249/magin.mp3")
})

sound.Add({
	name = "Weapon_Flakk249.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/schmung.M249/boltpull.mp3")
})

sound.Add({
	name = "Weapon_Flakk249.Boltrel",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/schmung.M249/boltrel.mp3")
})

sound.Add({
	name = "BlackVulcan.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound(")weapons/minigun/mini-1.wav")
})

sound.Add({
	name = "BlackVulcan.Boxout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound(")weapons/minigun/mini_boxout.mp3")
})


sound.Add({
	name = "BlackVulcan.Coverup",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound(")weapons/minigun/mini_coverup.mp3")
})

sound.Add({
	name = "BlackVulcan.Boxin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound(")weapons/minigun/mini_boxin.mp3")
})

sound.Add({
	name = "BlackVulcan.Chain",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound(")weapons/minigun/mini_chain.mp3")
})

sound.Add({
	name = "BlackVulcan.Coverdown",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound(")weapons/minigun/mini_coverdown.mp3")
})

sound.Add({
	name = "FG42_weapon.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/fg42/ak47-1.wav")
})

sound.Add({
	name = "FG42_weapon.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fg42/ak47_clipout.mp3")
})

sound.Add({
	name = "FG42_weapon.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fg42/ak47_clipin.mp3")
})

sound.Add({
	name = "FG42_weapon.BoltPull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/fg42/ak47_boltpull.mp3")
})

sound.Add({
	name = "Weapon_bar1.clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/jen.ak/mag.in.mp3")
})

sound.Add({
	name = "Weapon_bar1.clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/jen.ak/mag.out.mp3")
})

sound.Add({
	name = "Weapon_bar1.mag.tap",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/jen.ak/mag.tap.mp3")
})

sound.Add({
	name = "Weapon_bar1.boltpull",
	channel = CHAN_STATIC,
	volume = 0.7,
	sound = Sound("weapons/jen.ak/bolt.pull.mp3")
})

sound.Add({
	name = "Weapon_bar1.bolt.rel",
	channel = CHAN_STATIC,
	volume = 0.5,
	sound = Sound("weapons/jen.ak/bolt.rel.mp3")	
})

sound.Add({
	name = "Weapon_bar1.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/jen.ak/fire.wav")
})

sound.Add({
	name = "3rd_Weapon_bar1.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/jen.ak/fire.wav")	
})

sound.Add({
	name = "WepRem870.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/tact870/m3-1.wav")
})

sound.Add({
	name = "WepRem870.pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tact870/m3_pump.mp3")
})

sound.Add({
	name = "WepRem870.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/tact870/m3_insertshell.mp3")
})

sound.Add({
	name = "BenelliM3.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/BenelliM3/m3-1.wav")
})

sound.Add({
	name = "BenelliM3.insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/BenelliM3/m3_insertshell.mp3")
})

sound.Add({
	name = "BenelliM3.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/BenelliM3/m3_pump.mp3")
})

sound.Add({
	name = "Weapon_Scout.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2scout/scout_fire-1.wav")
})

sound.Add({
	name = "2eapon_scout.Boltback",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2scout/m24_boltback.mp3")
})

sound.Add({
	name = "2eapon_scout.boltforward",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2scout/m24_boltforward.mp3")
})

sound.Add({
	name = "2eapon_scout.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2scout/m24_magout.mp3")
})

sound.Add({
	name = "2eapon_scout.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2scout/m24_magin.mp3")
})

sound.Add({
	name = "Weapon_AWP.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2awp/awp1.wav")
})

sound.Add({
	name = "2eapon_AWP.Bolt",
	channel = CHAN_WEAPON,
	volume = 1,
	sound = Sound("weapons/2awp/awp_bolt.mp3")
})

sound.Add({
	name = "2eapon_AWP.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2awp/awp_clipout.mp3")
})

sound.Add({
	name = "2eapon_AWP.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2awp/awp_clipin.mp3")
})

sound.Add({
	name = "Weapon_G3SG1.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2g3sg1/g3sg1-1.wav")
})

sound.Add({
	name = "2eapon_PSG_1.Boltpull1",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2g3sg1/psg_1_boltpull1.mp3")
})

sound.Add({
	name = "2eapon_PSG_1.Boltpull2",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2g3sg1/psg_1_boltpull2.mp3")
})

sound.Add({
	name = "2eapon_PSG_1.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2g3sg1/psg_1_clipout.mp3")
})

sound.Add({
	name = "2eapon_PSG_1.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2g3sg1/psg_1_clipin.mp3")
})

sound.Add({
	name = "2eapon_PSG_1.Boltrelease",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2g3sg1/psg_1_boltrelease.mp3")
})

sound.Add({
	name = "2eapon_PSG_1.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2g3sg1/psg_1_draw.mp3")
})

sound.Add({
	name = "Weapon_M3Super.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/2m3/m3-1.wav")
})

sound.Add({
	name = "2eapon_M3.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2m3/m3_pump.mp3")
})

sound.Add({
	name = "2eapon_M3.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2m3/m3_insertshell.mp3")
})

sound.Add({
	name = "2eapon_M3.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2m3/cloth.mp3")
})

sound.Add({
	name = "Weapon_XM1014.1",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {Sound("weapons/2xm1014/xm1014-1.wav"),Sound("weapons/2xm1014/xm1014-2.wav")}
})

sound.Add({
	name = "2eapon_XM1014.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2xm1014/xm_cock.mp3")
})

sound.Add({
	name = "2eapon_XM1014.Boltpull",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2xm1014/xm_insert.mp3")
})

sound.Add({
	name = "2eapon_XM1014.Deploy",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/2xm1014/xm_deploy.mp3")
})

print("[MG] Included heavy weapons icons & sounds.")