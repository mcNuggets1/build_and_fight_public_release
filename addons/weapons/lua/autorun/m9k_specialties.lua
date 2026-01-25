if CLIENT then
	local icol = Color(255, 255, 255, 255) 
	killicon.Add("m9k_thrown_sticky_grenade", "vgui/hud/m9k_sticky_grenade", icol)
	killicon.Add("m9k_thrown_m61", "vgui/hud/m9k_m61_frag", icol)
	killicon.Add("m9k_m61_frag", "vgui/hud/m9k_m61_frag", icol)
	killicon.Add("m9k_thrown_smoke", "vgui/hud/m9k_smoke_grenade", icol)
	killicon.Add("m9k_smoke_grenade", "vgui/hud/m9k_smoke_grenade", icol)
	killicon.Add("m9k_thrown_bat", "vgui/hud/m9k_baseball_bat", icol)
	killicon.Add("m9k_thrown_machete", "vgui/hud/m9k_machete", icol)
	killicon.Add("m9k_thrown_harpoon", "vgui/hud/m9k_harpoon", icol)
	killicon.Add("m9k_released_gas", "vgui/hud/m9k_nerve_gas", icol)
	killicon.Add("m9k_proxy", "vgui/hud/m9k_proxy_mine", icol)
	killicon.Add("m9k_milkor_nade", "vgui/hud/m9k_milkormgl", icol)
	killicon.Add("m9k_suicide_bomb", "vgui/hud/m9k_suicide_bomb", icol)
	killicon.Add("m9k_mad_c4", "vgui/hud/m9k_suicide_bomb", icol)
	killicon.Add("m9k_m202_rocket", "vgui/hud/m9k_m202", icol)
	killicon.Add("m9k_launched_m79", "vgui/hud/m9k_m79gl", icol)
	killicon.Add("m9k_improvised_explosive", "vgui/hud/m9k_ied_detonator", icol)
	killicon.Add("m9k_gdcwa_matador_90mm", "vgui/hud/m9k_matador", icol)
	killicon.Add("m9k_gdcwa_rpg_heat", "vgui/hud/m9k_rpg7", icol)
	killicon.Add("m9k_damascus", "vgui/hud/m9k_damascus", icol)
	killicon.Add("m9k_machete", "vgui/hud/m9k_machete", icol)
	killicon.Add("m9k_launched_ex41", "vgui/hud/m9k_ex41", icol)
	killicon.Add("m9k_orbital_cannon", "vgui/hud/m9k_orbital_strike", icol)
	killicon.Add("m9k_baseball_bat", "vgui/hud/m9k_baseball_bat", icol)
	killicon.Add("m9k_knife", "vgui/hud/m9k_knife", icol)
	killicon.Add("m9k_thrown_knife", "vgui/hud/m9k_knife", icol)
	killicon.Add("m9k_nitro_vapor", "vgui/hud/m9k_nitro", icol)

	killicon.Add("m9k_planted_c4", "vgui/hud/m9k_c4", icol)
	killicon.Add("m9k_thrown_hatchet", "vgui/hud/m9k_hatchet", icol)
end

sound.Add({
	name = "EX41.Pump",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/ex41/m3_pump.mp3")
})

sound.Add({
	name = "EX41.Insertshell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/ex41/m3_insertshell.mp3")
})

sound.Add({
	name = "EX41.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/ex41/draw.mp3")
})

sound.Add({
	name = "RPGF.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	soundlevel = 155,
	sound = Sound("gdc/rockets/rpgf.wav")
})

sound.Add({
	name = "M202F.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	soundlevel = 155,
	sound = {Sound("gdc/rockets/m202f.wav"), Sound("gdc/rockets/m202f2.wav")}
})

sound.Add({
	name = "MATADORF.single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	soundlevel = 155,
	sound = Sound("gdc/rockets/matadorf.wav")
})

sound.Add({
	name = "sb.click",
	channel = CHAN_USER_BASE+10,
	volume = "1",
	sound = Sound("weapons/suicidebomb/c4_click.mp3")
})

sound.Add({
	name = "M79_launcher.close",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m79/m79_close.mp3")
})

sound.Add({
	name = "M79_glauncher.barrelup",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m79/barrelup.mp3")
})

sound.Add({
	name = "M79_glauncher.InsertShell",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m79/xm_insert.mp3")
})

sound.Add({
	name = "M79_launcher.draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = Sound("weapons/m79/m79_close.mp3")
})

sound.Add({
	name = "40mmGrenade.Single",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = Sound("weapons/m79/40mmthump.wav")
})

sound.Add({
	name = "BaseballBat.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("player/weapon_draw_01.wav"),
		Sound("player/weapon_draw_02.wav"),
		Sound("player/weapon_draw_03.wav"),
	}
})

sound.Add({
	name = "BaseballBat.Swing",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {
		Sound("weapons/melee/swing_light_blunt_01.wav"),
		Sound("weapons/melee/swing_light_blunt_02.wav"),
		Sound("weapons/melee/swing_light_blunt_03.wav"),
	}
})

sound.Add({
	name = "BaseballBat.HitWorld",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/metal/hitlight1.wav"),
		Sound("nmrihimpact/metal/hitlight2.wav"),
		Sound("nmrihimpact/metal/hitlight3.wav"),
	}
})

sound.Add({
	name = "BaseballBat.HitFlesh",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/blunt_light1.wav"),
		Sound("nmrihimpact/blunt_light2.wav"),
		Sound("nmrihimpact/blunt_light3.wav"),
	}
})

sound.Add({
	name = "Knife.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("weapons/doipack/shared/melee/bayonet_draw_01.wav"),
		Sound("weapons/doipack/shared/melee/bayonet_draw_02.wav"),
		Sound("weapons/doipack/shared/melee/bayonet_draw_03.wav"),
	}
})

sound.Add({
	name = "Knife.Swing",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {
		Sound("weapons/doipack/shared/melee/weapon_melee_01.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_02.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_03.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_04.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_05.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_06.wav"),
	}
})

sound.Add({
	name = "Knife.HitWorld",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("weapons/doipack/shared/melee/weapon_melee_hitworld_01.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_hitworld_02.wav"),
	}
})

sound.Add({
	name = "Knife.HitFlesh",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("weapons/doipack/shared/melee/weapon_melee_hitflesh_01.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_hitflesh_02.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_hitflesh_03.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_hitflesh_04.wav"),
	}
})

sound.Add({
	name = "Machete.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("weapons/doipack/shared/melee/bayonet_draw_01.wav"),
		Sound("weapons/doipack/shared/melee/bayonet_draw_02.wav"),
		Sound("weapons/doipack/shared/melee/bayonet_draw_03.wav"),
	}
})

sound.Add({
	name = "Machete.Swing",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {
		Sound("weapons/melee/swing_light_sharp_01.wav"),
		Sound("weapons/melee/swing_light_sharp_02.wav"),
		Sound("weapons/melee/swing_light_sharp_03.wav"),
	}
})

sound.Add({
	name = "Machete.HitWorld",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/metal/metal_solid_impact_bullet1.wav"),
		Sound("nmrihimpact/metal/metal_solid_impact_bullet2.wav"),
	}
})

sound.Add({
	name = "Machete.HitFlesh",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/sharp_light1.wav"),
		Sound("nmrihimpact/sharp_light2.wav"),
		Sound("nmrihimpact/sharp_light3.wav"),
	}
})

sound.Add({
	name = "Sledgehammer.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("player/weapon_draw_01.wav"),
		Sound("player/weapon_draw_02.wav"),
		Sound("player/weapon_draw_03.wav"),
	}
})

sound.Add({
	name = "Sledgehammer.Swing",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {
		Sound("weapons/melee/swing_heavy_blunt_01.wav"),
		Sound("weapons/melee/swing_heavy_blunt_02.wav"),
		Sound("weapons/melee/swing_heavy_blunt_03.wav"),
	}
})

sound.Add({
	name = "Sledgehammer.Swing2",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {
		Sound("weapons/melee/swing_light_blunt_01.wav"),
		Sound("weapons/melee/swing_light_blunt_02.wav"),
		Sound("weapons/melee/swing_light_blunt_03.wav"),
	}
})

sound.Add({
	name = "Sledgehammer.HitWorld",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/concrete/concrete_impact_bullet2.wav"),
		Sound("nmrihimpact/concrete/concrete_impact_bullet3.wav"),
	}
})

sound.Add({
	name = "Sledgehammer.HitFlesh",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/blunt_heavy1.wav"),
		Sound("nmrihimpact/blunt_heavy2.wav"),
		Sound("nmrihimpact/blunt_heavy3.wav"),
		Sound("nmrihimpact/blunt_heavy4.wav"),
	}
})

sound.Add({
	name = "Spade.Swing",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {
		Sound("weapons/doipack/shared/melee/weapon_melee_01.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_02.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_03.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_04.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_05.wav"),
		Sound("weapons/doipack/shared/melee/weapon_melee_06.wav"),
	}
})

sound.Add({
	name = "Spade.HitWorld",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_01.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_02.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_03.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_04.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_05.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_06.wav"),
	}
})

sound.Add({
	name = "Spade.HitFlesh",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_001.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_002.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_003.wav"),
		Sound("weapons/doipack/entrenchingtool/ent_tool_melee_004.wav"),
	}
})

sound.Add({
	name = "Hatchet.Draw",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("weapons/doipack/shared/melee/bayonet_draw_01.wav"),
		Sound("weapons/doipack/shared/melee/bayonet_draw_02.wav"),
		Sound("weapons/doipack/shared/melee/bayonet_draw_03.wav"),
	}
})

sound.Add({
	name = "Hatchet.Swing",
	channel = CHAN_USER_BASE+10,
	volume = 1,
	sound = {
		Sound("weapons/melee/swing_light_sharp_01.wav"),
		Sound("weapons/melee/swing_light_sharp_02.wav"),
		Sound("weapons/melee/swing_light_sharp_03.wav"),
	}
})

sound.Add({
	name = "Hatchet.HitWorld",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/metal/metal_solid_impact_bullet1.wav"),
		Sound("nmrihimpact/metal/metal_solid_impact_bullet2.wav"),
	}
})

sound.Add({
	name = "Hatchet.HitFlesh",
	channel = CHAN_STATIC,
	volume = 1,
	sound = {
		Sound("nmrihimpact/sharp_heavy1.wav"),
		Sound("nmrihimpact/sharp_heavy2.wav"),
		Sound("nmrihimpact/sharp_heavy3.wav"),
		Sound("nmrihimpact/sharp_heavy4.wav"),
	}
})

print("[MG] Included specialties icons & sounds.")