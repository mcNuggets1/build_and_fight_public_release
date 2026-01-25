TOOL.Category = "Build & Fight"
TOOL.Name = "#tool.lightsaber"

TOOL.ClientConVar["model"] = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl"
TOOL.ClientConVar["red"] = "0"
TOOL.ClientConVar["green"] = "127"
TOOL.ClientConVar["blue"] = "255"
TOOL.ClientConVar["bladew"] = "2"
TOOL.ClientConVar["bladel"] = "42"

TOOL.ClientConVar["dark"] = "0"
TOOL.ClientConVar["starton"] = "1"

TOOL.ClientConVar["humsound"] = "lightsaber/saber_loop1.wav"
TOOL.ClientConVar["swingsound"] = "lightsaber/saber_swing1.wav"
TOOL.ClientConVar["onsound"] = "lightsaber/saber_on1.wav"
TOOL.ClientConVar["offsound"] = "lightsaber/saber_off1.wav"

cleanup.Register("lightsabers")

if SERVER then
	CreateConVar("sbox_maxlightsabers", 1)

	function MakeLightsaber(ply, model, pos, ang, LoopSound, SwingSound, OnSound, OffSound)
		if (IsValid(ply) and !ply:CheckLimit("lightsabers")) then return false end
		local lightsaber = ents.Create("lightsaber")
		if !IsValid(lightsaber) then return false end
		lightsaber:SetModel(model)
		lightsaber:SetAngles(ang)
		lightsaber:SetPos(pos)
		table.Merge(lightsaber:GetTable(), {Owner = ply,LoopSound = LoopSound, SwingSound = SwingSound,OnSound = OnSound, OffSound = OffSound})
		lightsaber:Spawn()
		lightsaber:Activate()
		if IsValid(ply) then
			ply:AddCount("lightsabers", lightsaber)
			ply:AddCleanup("lightsabers", lightsaber)
		end
		DoPropSpawnedEffect(lightsaber)
		return lightsaber
	end
	duplicator.RegisterEntityClass("lightsaber", MakeLightsaber, "model", "pos", "ang", "LoopSound", "SwingSound", "OnSound", "OffSound")
end

if CLIENT then
	language.Add("max_lightsabers", "Maximale Lichtschwerter")
end

function TOOL:LeftClick(trace)
	if (trace.HitSky or !trace.HitPos) then return false end
	if (IsValid(trace.Entity) and (trace.Entity:GetClass() == "lightsaber" or trace.Entity:IsPlayer())) then return false end
	if CLIENT then return true end
	local ply = self:GetOwner()
	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch - 90
	if (trace.HitNormal.z > 0.99) then ang.y = ply:GetAngles().y end
	local r = self:GetClientNumber("red")
	local g = self:GetClientNumber("green")
	local b = self:GetClientNumber("blue")
	local hs = LS_LightsaberHumSounds[self:GetClientInfo("humsound")] and self:GetClientInfo("humsound") or "lightsaber/saber_loop1.wav"
	local ss = LS_LightsaberSwingSounds[self:GetClientInfo("swingsound")] and self:GetClientInfo("swingsound") or "lightsaber/saber_swing1.wav"
	local ons = LS_LightsaberOnSounds[self:GetClientInfo("onsound")] and self:GetClientInfo("onsound") or "lightsaber/saber_on1.wav"
	local offs = LS_LightSaberOffSounds[self:GetClientInfo("offsound")] and self:GetClientInfo("offsound") or "lightsaber/saber_off1.wav"
	local dark = self:GetClientNumber("dark")
	local enabled = self:GetClientNumber("starton")
	local bld_w = math.Clamp(self:GetClientNumber("bladew"), 2, 4)
	local bld_len = math.Clamp(self:GetClientNumber("bladel"), 32, 64)
	local lightsaber = MakeLightsaber(ply, LS_LightsaberModels[self:GetClientInfo("model")] and self:GetClientInfo("model") or "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl", trace.HitPos, ang, hs, ss, ons, offs)
	if !IsValid(lightsaber) then return end
	lightsaber:SetDarkInner(tobool(dark))
	lightsaber:SetMaxLength(bld_len)
	lightsaber:SetBladeWidth(bld_w)
	lightsaber:SetCrystalColor(Vector(r, g, b) / 255)
	lightsaber:SetEnabled(tobool(enabled))
	local min = lightsaber:OBBMins()
	lightsaber:SetPos(trace.HitPos - trace.HitNormal * min.z)
	local phys = lightsaber:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end
	undo.Create("lightsaber")
		undo.AddEntity(lightsaber)
		undo.SetPlayer(ply)
	undo.Finish()
	return true
end

function TOOL:UpdateGhostEntity(ent, ply)
	if !IsValid(ent) then return end
	local trace = ply:GetEyeTrace()
	if !trace.Hit then ent:SetNoDraw(true) return end
	if (IsValid(trace.Entity) and trace.Entity:GetClass() == "lightsaber" or trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then ent:SetNoDraw(true) return end
	local ang = trace.HitNormal:Angle()
	ang.p = ang.p - 90
	if (trace.HitNormal.z > 0.99) then
		ang.y = ply:GetAngles().y
	end
	local min = ent:OBBMins()
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
	ent:SetAngles(ang)
	ent:SetNoDraw(false)
end

function TOOL:Think()
	if (!IsValid(self.GhostEntity) or self.GhostEntity:GetModel() != self:GetClientInfo("model")) then
		self:MakeGhostEntity(self:GetClientInfo("model"), Vector(0, 0, 0), Angle(0, 0, 0))
	end
	self:UpdateGhostEntity(self.GhostEntity, self:GetOwner())
end

if SERVER then return end

TOOL.Information = {
	{name = "left"}
}

language.Add("tool.lightsaber", "Lichtschwerter")
language.Add("tool.lightsaber.name", "Lichtschwerter")
language.Add("tool.lightsaber.desc", "Erstelle eigene Lichtschwerter.")
language.Add("tool.lightsaber.0", "Linksklick um ein Lichtschwert zu erstellen.")
language.Add("tool.lightsaber.left", "Erstelle ein Lichtschwert")
language.Add("tool.lightsaber.model", "Griff")
language.Add("tool.lightsaber.color", "Kristallfarbe")
language.Add("tool.lightsaber.take", "Nehme dieses Lichtschwert!")

language.Add("tool.lightsaber.DarkInner", "Dunkle innere Klinge")
language.Add("tool.lightsaber.StartEnabled", "Bei Spawn aktivieren")

language.Add("tool.lightsaber.HumSound", "Brummklang")
language.Add("tool.lightsaber.SwingSound", "Schwungklang")
language.Add("tool.lightsaber.IgniteSound", "Schweißklang")

language.Add("tool.lightsaber.HudBlur", "HUD-BLUR aktivieren")

language.Add("tool.lightsaber.bladew", "Klingendicke")
language.Add("tool.lightsaber.bladel", "Klingenlänge")

language.Add("tool.lightsaber.jedi", "Jedi")
language.Add("tool.lightsaber.jedi_fast", "Jedi / Schnell")
language.Add("tool.lightsaber.sith", "Sith")
language.Add("tool.lightsaber.sith_fast", "Sith / Schnell")
language.Add("tool.lightsaber.heavy", "Schwer")
language.Add("tool.lightsaber.heavy_fast", "Schwer / Schnell")
language.Add("tool.lightsaber.jedi2", "Jedi / Original")
language.Add("tool.lightsaber.jedi2_fast", "Jedi / Original / Schnell")
language.Add("tool.lightsaber.dark", "Dunkles Schwert")

language.Add("tool.lightsaber.hum.1", "Standardmäßig")
language.Add("tool.lightsaber.hum.2", "Sith / Schwer")
language.Add("tool.lightsaber.hum.3", "Mittelmäßig")
language.Add("tool.lightsaber.hum.4", "Schwer")
language.Add("tool.lightsaber.hum.5", "Sith-Assassine / Leicht")
language.Add("tool.lightsaber.hum.6", "Darth Vader")
language.Add("tool.lightsaber.hum.7", "Schwer")
language.Add("tool.lightsaber.hum.8", "Count Dooku")

language.Add("Cleanup_lightsabers", "Lightsabers")
language.Add("Cleaned_lightsabers", "Cleaned up all Lightsabers")
language.Add("SBoxLimit_lightsabers", "You've hit the Lightsaber limit!")
language.Add("Undone_lightsaber", "Undone Lightsaber")

language.Add("tool.lightsaber.preset1", "Darth Mauls Doppelklinge")
language.Add("tool.lightsaber.preset2", "Darth Mauls Lichtschwert")
language.Add("tool.lightsaber.preset3", "Darth Tyrannus' Lichtschwert (Count Dooku)")
language.Add("tool.lightsaber.preset4", "Darth Sidious' Lichtschwert")
language.Add("tool.lightsaber.preset5", "Darth Vaders Lichtschwert")

language.Add("tool.lightsaber.preset6", "Master Yodas Lichtschwert")
language.Add("tool.lightsaber.preset7", "Qui-Gon Jinns Lichtschwert")
language.Add("tool.lightsaber.preset8", "Mace Windus Lichtschwert")
language.Add("tool.lightsaber.preset9", "[EP3] Obi-Wan Kenobis Lichtschwert")
language.Add("tool.lightsaber.preset10", "[EP1] Obi-Wan Kenobis Lichtschwert")
language.Add("tool.lightsaber.preset11", "[EP6] Luke Skywalkers Lichtschwert")
language.Add("tool.lightsaber.preset12", "[EP2] Anakin Skywalkers Lichtschwert")
language.Add("tool.lightsaber.preset13", "[EP3] Anakin Skywalkers Lichtschwert")
language.Add("tool.lightsaber.preset14", "Normales Jedi-Lichtschwert")
language.Add("tool.lightsaber.preset15", "Dunkles Schwert")

local ConVarsDefault = TOOL:BuildConVarList()
local Presets = {
	["#preset.default"] = ConVarsDefault,
	["#tool.lightsaber.preset1"] = {
		lightsaber_model = "models/weapons/starwars/w_maul_saber_staff_hilt.mdl",
		lightsaber_red = "255",
		lightsaber_green = "0",
		lightsaber_blue = "0",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.4",
		lightsaber_bladel = "45",
		lightsaber_humsound = "lightsaber/saber_loop7.wav",
		lightsaber_swingsound = "lightsaber/saber_swing2.wav",
		lightsaber_onsound = "lightsaber/saber_on2.wav",
		lightsaber_offsound = "lightsaber/saber_off2.wav"
	},
	["#tool.lightsaber.preset2"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_maul_saber_half_hilt.mdl",
		lightsaber_red = "255",
		lightsaber_green = "0",
		lightsaber_blue = "0",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.4",
		lightsaber_bladel = "45",
		lightsaber_humsound = "lightsaber/saber_loop7.wav",
		lightsaber_swingsound = "lightsaber/saber_swing2.wav",
		lightsaber_onsound = "lightsaber/saber_on2.wav",
		lightsaber_offsound = "lightsaber/saber_off2.wav"
	},
	["#tool.lightsaber.preset3"] = {
		lightsaber_model = "models/weapons/starwars/w_dooku_saber_hilt.mdl",
		lightsaber_red = "255",
		lightsaber_green = "0",
		lightsaber_blue = "0",
		lightsaber_dark = "0",
		lightsaber_bladew = "2",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop8.wav",
		lightsaber_swingsound = "lightsaber/saber_swing2.wav",
		lightsaber_onsound = "lightsaber/saber_on2.wav",
		lightsaber_offsound = "lightsaber/saber_off2.wav"
	},
	["#tool.lightsaber.preset4"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_sidious_saber_hilt.mdl",
		lightsaber_red = "255",
		lightsaber_green = "0",
		lightsaber_blue = "0",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.2",
		lightsaber_bladel = "43",
		lightsaber_humsound = "lightsaber/saber_loop5.wav",
		lightsaber_swingsound = "lightsaber/saber_swing2.wav",
		lightsaber_onsound = "lightsaber/saber_on2.wav",
		lightsaber_offsound = "lightsaber/saber_off2.wav"
	},
	["#tool.lightsaber.preset5"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_vader_saber_hilt.mdl",
		lightsaber_red = "255",
		lightsaber_green = "0",
		lightsaber_blue = "0",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.25",
		lightsaber_bladel = "43",
		lightsaber_humsound = "lightsaber/saber_loop6.wav",
		lightsaber_swingsound = "lightsaber/saber_swing2.wav",
		lightsaber_onsound = "lightsaber/saber_on2.wav",
		lightsaber_offsound = "lightsaber/saber_off2.wav"
	},
	["#tool.lightsaber.preset6"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_yoda_saber_hilt.mdl",
		lightsaber_red = "64",
		lightsaber_green = "255",
		lightsaber_blue = "64",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.3",
		lightsaber_bladel = "40",
		lightsaber_humsound = "lightsaber/saber_loop3.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset7"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_quigon_gin_saber_hilt.mdl",
		lightsaber_red = "32",
		lightsaber_green = "255",
		lightsaber_blue = "32",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.2",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset8"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_mace_windu_saber_hilt.mdl",
		lightsaber_red = "127",
		lightsaber_green = "0",
		lightsaber_blue = "255",
		lightsaber_dark = "0",
		lightsaber_bladew = "2",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset9"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_obiwan_ep3_saber_hilt.mdl",
		lightsaber_red = "48",
		lightsaber_green = "255",
		lightsaber_blue = "48",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.1",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset10"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_obiwan_ep1_saber_hilt.mdl",
		lightsaber_red = "48",
		lightsaber_green = "255",
		lightsaber_blue = "48",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.1",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset11"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_luke_ep6_saber_hilt.mdl",
		lightsaber_red = "32",
		lightsaber_green = "255",
		lightsaber_blue = "32",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.1",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset12"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl",
		lightsaber_red = "0",
		lightsaber_green = "100",
		lightsaber_blue = "255",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.1",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset13"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_anakin_ep3_saber_hilt.mdl",
		lightsaber_red = "0",
		lightsaber_green = "100",
		lightsaber_blue = "255",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.1",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset14"] = {
		lightsaber_model = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl",
		lightsaber_dark = "0",
		lightsaber_bladew = "2.2",
		lightsaber_bladel = "42",
		lightsaber_humsound = "lightsaber/saber_loop1.wav",
		lightsaber_swingsound = "lightsaber/saber_swing1.wav",
		lightsaber_onsound = "lightsaber/saber_on1.wav",
		lightsaber_offsound = "lightsaber/saber_off1.wav"
	},
	["#tool.lightsaber.preset15"] = {
		lightsaber_red = "255",
		lightsaber_green = "255",
		lightsaber_blue = "255",
		lightsaber_dark = "1",
		lightsaber_humsound = "lightsaber/darksaber_loop.wav",
		lightsaber_swingsound = "lightsaber/darksaber_swing.wav",
		lightsaber_onsound = "lightsaber/darksaber_on.wav",
		lightsaber_offsound = "lightsaber/darksaber_off.wav"
	},
}

function TOOL:BuildCPanel()
	self:AddControl("ComboBox", {MenuButton = 1, Folder = "lightsabers", Options = Presets, CVars = table.GetKeys(ConVarsDefault)})
	self:AddControl("PropSelect", {Label = "#tool.lightsaber.model", Height = 4, ConVar = "lightsaber_model", Models = list.Get("LightsaberModels")})
	self:AddControl("Color", {Label = "#tool.lightsaber.color", Red = "lightsaber_red", Green = "lightsaber_green", Blue = "lightsaber_blue", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1"})
	self:AddControl("Checkbox", {Label = "#tool.lightsaber.DarkInner", Command = "lightsaber_dark"})
	self:AddControl("Checkbox", {Label = "#tool.lightsaber.StartEnabled", Command = "lightsaber_starton"})
	self:AddControl("Slider", {Label = "#tool.lightsaber.bladeW", Type = "Float", Min = 2, Max = 4, Command = "lightsaber_bladew"})
	self:AddControl("Slider", {Label = "#tool.lightsaber.bladeL", Type = "Float", Min = 32, Max = 64, Command = "lightsaber_bladel"})
	self:AddControl("ComboBox", {Label = "#tool.lightsaber.HumSound", MenuButton = "0", Options = list.Get("LightsaberHumSounds")})
	self:AddControl("ComboBox", {Label = "#tool.lightsaber.SwingSound", MenuButton = "0", Options = list.Get("LightsaberSwingSounds")})
	self:AddControl("ComboBox", {Label = "#tool.lightsaber.IgniteSound", MenuButton = "0", Options = list.Get("LightsaberIgniteSounds")})
	self:AddControl("Checkbox", {Label = "#tool.lightsaber.HudBlur", Command = "lightsaber_hud_blur"})
end

list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.1", {lightsaber_humsound = "lightsaber/saber_loop1.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.2", {lightsaber_humsound = "lightsaber/saber_loop2.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.3", {lightsaber_humsound = "lightsaber/saber_loop3.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.4", {lightsaber_humsound = "lightsaber/saber_loop4.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.5", {lightsaber_humsound = "lightsaber/saber_loop5.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.6", {lightsaber_humsound = "lightsaber/saber_loop6.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.7", {lightsaber_humsound = "lightsaber/saber_loop7.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.hum.8", {lightsaber_humsound = "lightsaber/saber_loop8.wav"})
list.Set("LightsaberHumSounds", "#tool.lightsaber.dark", {lightsaber_humsound = "lightsaber/darksaber_loop.wav"})
list.Set("LightsaberSwingSounds", "#tool.lightsaber.jedi", {lightsaber_swingsound = "lightsaber/saber_swing1.wav"})
list.Set("LightsaberSwingSounds", "#tool.lightsaber.sith", {lightsaber_swingsound = "lightsaber/saber_swing2.wav"})
list.Set("LightsaberSwingSounds", "#tool.lightsaber.dark", {lightsaber_swingsound = "lightsaber/darksaber_swing.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.jedi", {lightsaber_onsound = "lightsaber/saber_on1.wav", lightsaber_offsound = "lightsaber/saber_off1.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.jedi_fast", {lightsaber_onsound = "lightsaber/saber_on1_fast.wav", lightsaber_offsound = "lightsaber/saber_off1_fast.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.sith", {lightsaber_onsound = "lightsaber/saber_on2.wav", lightsaber_offsound = "lightsaber/saber_off2.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.sith_fast", {lightsaber_onsound = "lightsaber/saber_on2_fast.wav", lightsaber_offsound = "lightsaber/saber_off2_fast.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.heavy", {lightsaber_onsound = "lightsaber/saber_on3.wav", lightsaber_offsound = "lightsaber/saber_off3.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.heavy_fast", {lightsaber_onsound = "lightsaber/saber_on3_fast.wav", lightsaber_offsound = "lightsaber/saber_off3_fast.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.jedi2", {lightsaber_onsound = "lightsaber/saber_on4.wav", lightsaber_offsound = "lightsaber/saber_off4.mp3"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.jedi2_fast", {lightsaber_onsound = "lightsaber/saber_on4_fast.wav", lightsaber_offsound = "lightsaber/saber_off4_fast.wav"})
list.Set("LightsaberIgniteSounds", "#tool.lightsaber.dark", {lightsaber_onsound = "lightsaber/darksaber_on.wav", lightsaber_offsound = "lightsaber/darksaber_off.wav"})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_anakin_ep3_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_luke_ep6_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_mace_windu_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_maul_saber_half_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_obiwan_ep1_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_obiwan_ep3_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_quigon_gin_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_sidious_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_vader_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/sgg/starwars/weapons/w_yoda_saber_hilt.mdl", {})
list.Set("LightsaberModels", "models/weapons/starwars/w_maul_saber_staff_hilt.mdl", {})
list.Set("LightsaberModels", "models/weapons/starwars/w_dooku_saber_hilt.mdl", {})