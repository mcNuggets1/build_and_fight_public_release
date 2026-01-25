if SERVER then
	AddCSLuaFile()
end

local tr = {
	["models/sgg/starwars/weapons/w_maul_saber_hilt.mdl"] = "models/weapons/starwars/w_maul_saber_staff_hilt.mdl",
	["models/sgg/starwars/weapons/w_maul_saberstaff_hilt.mdl"] = "models/weapons/starwars/w_maul_saber_staff_hilt.mdl",
	["models/sgg/starwars/weapons/w_dooku_saber_hilt.mdl"] = "models/weapons/starwars/w_dooku_saber_hilt.mdl",
	["lightsaber/darksaberloop.wav"] = "lightsaber/darksaber_loop.wav",
	["lightsaber/darksaberoff.wav"] = "lightsaber/darksaber_on.wav",
	["lightsaber/darksaberon.wav"] = "lightsaber/darksaber_off.wav",
	["lightsaber/darksaberswing.wav"] = "lightsaber/darksaber_swing.wav",
	["lightsaber/forceleap.wav"] = "lightsaber/force_leap.wav",
	["lightsaber/forcerepulse.wav"] = "lightsaber/force_repulse.wav",
	["lightsaber/forcelightning1.wav"] = "lightsaber/force_lightning1.wav",
	["lightsaber/forcelightning2.wav"] = "lightsaber/force_lightning2.wav",
	["lightsaber/saberhit.wav"] = "lightsaber/saber_hit.wav",
	["lightsaber/saberhitlaser1.wav"] = "lightsaber/saber_hit_laser1.wav",
	["lightsaber/saberhitlaser2.wav"] = "lightsaber/saber_hit_laser2.wav",
	["lightsaber/saberhitlaser3.wav"] = "lightsaber/saber_hit_laser3.wav",
	["lightsaber/saberhitlaser4.wav"] = "lightsaber/saber_hit_laser4.wav",
	["lightsaber/saberhitlaser5.wav"] = "lightsaber/saber_hit_laser5.wav",
	["lightsaber/saberswing1.wav"] = "lightsaber/saber_swing1.wav",
	["lightsaber/saberswing2.wav"] = "lightsaber/saber_swing2.wav",
	["lightsaber/saberloop1.wav"] = "lightsaber/saber_loop1.wav",
	["lightsaber/saberloop2.wav"] = "lightsaber/saber_loop2.wav",
	["lightsaber/saberloop3.wav"] = "lightsaber/saber_loop3.wav",
	["lightsaber/saberloop4.wav"] = "lightsaber/saber_loop4.wav",
	["lightsaber/saberloop5.wav"] = "lightsaber/saber_loop5.wav",
	["lightsaber/saberloop6.wav"] = "lightsaber/saber_loop6.wav",
	["lightsaber/saberloop7.wav"] = "lightsaber/saber_loop7.wav",
	["lightsaber/saberloop8.wav"] = "lightsaber/saber_loop8.wav",
	["lightsaber/saberon1.wav"] = "lightsaber/saber_on1.wav",
	["lightsaber/saberon1_fast.wav"] = "lightsaber/saber_on1_fast.wav",
	["lightsaber/saberoff1.wav"] = "lightsaber/saber_off1.wav",
	["lightsaber/saberoff1_fast.wav"] = "lightsaber/saber_off1_fast.wav",
	["lightsaber/saberon2.wav"] = "lightsaber/saber_on2.wav",
	["lightsaber/saberon2_fast.wav"] = "lightsaber/saber_on2_fast.wav",
	["lightsaber/saberoff2.wav"] = "lightsaber/saber_off2.wav",
	["lightsaber/saberoff2_fast.wav"] = "lightsaber/saber_off2_fast.wav",
	["lightsaber/saberon3.wav"] = "lightsaber/saber_on3.wav",
	["lightsaber/saberon3_fast.wav"] = "lightsaber/saber_on3_fast.wav",
	["lightsaber/saberoff3.wav"] = "lightsaber/saber_off3.wav",
	["lightsaber/saberoff3_fast.wav"] = "lightsaber/saber_off3_fast.wav",
	["lightsaber/saberon4.wav"] = "lightsaber/saber_on4.wav",
	["lightsaber/saberon4_fast.wav"] = "lightsaber/saber_on4_fast.wav",
	["lightsaber/saberoff4.wav"] = "lightsaber/saber_off4.wav",
	["lightsaber/saberoff4_fast.wav"] = "lightsaber/saber_off4_fast.wav",
	["lightsaber/saberon4.mp3"] = "lightsaber/saber_on4.wav",
	["lightsaber/saberoff4.mp3"] = "lightsaber/saber_off4.wav",
}

local convars = {
	"lightsaber_model",
	"lightsaber_humsound",
	"lightsaber_swingsound",
	"lightsaber_onsound",
	"lightsaber_offsound",
}

hook.Add("Initialize", "lightsaber_saveconvars", function()
	if !GetConVar("lightsaber_model") then return end
	for id, cvar in pairs(convars) do
		if tr[GetConVar(cvar):GetString():lower()] then
			RunConsoleCommand(cvar, tr[GetConVar(cvar):GetString():lower()])
		end
	end
end)

local HardLaser = Material("lightsaber/hard_light")
local HardLaserInner = Material("lightsaber/hard_light_inner")

local HardLaserTrail = Material("lightsaber/hard_light_trail")
local HardLaserTrailInner = Material("lightsaber/hard_light_trail_inner")

local HardLaserTrailEnd = Material("lightsaber/hard_light_trail_end")
local HardLaserTrailEndInner = Material("lightsaber/hard_light_trail_end_inner")

local HardLaserTrailEnd = Material("lightsaber/hard_light_trail")
local HardLaserTrailEndInner = Material("lightsaber/hard_light_trail_inner")

local gOldPositions = {}
local gTrailLength = 1
local lastTime = 0

function LS_RenderBlade(ent, pos, dir, len, maxlen, width, color, black_inner, eid, underwater)
	if (len <= 0) then LS_SaberClean(eid) return end
	if underwater then
		local ed = EffectData()
		ed:SetOrigin(pos)
		ed:SetNormal(dir)
		ed:SetRadius(len)
		util.Effect("saber_underwater", ed)
	end
	local inner_color = color_white
	if black_inner then inner_color = color_black end
	render.SetMaterial(HardLaser)
	render.DrawBeam(pos, pos + dir * len, width, 1, 0.01, color)
	render.SetMaterial(HardLaserInner)
	render.DrawBeam(pos, pos + dir * len, width * 1.2, 1, 0.01, inner_color)
	local SaberLight = DynamicLight(eid)
	if SaberLight then
		SaberLight.Pos = pos + dir * (len / 2)
		SaberLight.r = color.r
		SaberLight.g = color.g
		SaberLight.b = color.b
		SaberLight.Brightness = 0.6
		SaberLight.Size = 176 * (len / maxlen)
		SaberLight.Decay = 0
		SaberLight.DieTime = CurTime() + 0.1
	end
	local prevB = pos
	local prevT = pos + dir * len
	if !gOldPositions[eid] then gOldPositions[eid] = {} end
	for id, prevpos in ipairs(gOldPositions[eid]) do
		local posB = prevpos.pos
		local posT = prevpos.pos + prevpos.dir * prevpos.len
		if (id == gTrailLength) then
			HardLaserTrailEnd:SetVector("$color", Vector(color.r / 255, color.g / 255, color.b / 255))
			render.SetMaterial(HardLaserTrailEnd)
		else
			HardLaserTrail:SetVector("$color", Vector(color.r / 255, color.g / 255, color.b / 255))
			render.SetMaterial(HardLaserTrail)
		end
		render.DrawQuad(posB, prevB, prevT, posT)
		if (id == gTrailLength) then
			HardLaserTrailEndInner:SetVector("$color", Vector(inner_color.r / 255, inner_color.g / 255, inner_color.b / 255))
			render.SetMaterial(HardLaserTrailEndInner)
		else
			HardLaserTrailInner:SetVector("$color", Vector(inner_color.r / 255, inner_color.g / 255, inner_color.b / 255))
			render.SetMaterial(HardLaserTrailInner)
		end
		render.DrawQuad(posB, prevB, prevT, posT)
		prevB = prevpos.pos
		prevT = prevpos.pos + prevpos.dir * prevpos.len
	end
end

function LS_SaberClean(eid)
	gOldPositions[eid] = nil
	gOldPositions[eid + 655] = nil
end

function LS_ProcessEntity(eid, pos, dir, len)
	if !gOldPositions[eid] then gOldPositions[eid] = {} end
	for i = 0, gTrailLength - 1 do
		gOldPositions[eid][gTrailLength - i] = gOldPositions[eid][gTrailLength - i - 1]
		if (gTrailLength - i == 1) then
			gOldPositions[eid][1] = {dir = dir, len = len, pos = pos}
		end
	end
end

if CLIENT then
	local lightsabers = {}
	local lightsaber_ents = {}

	hook.Add("NetworkEntityCreated", "lightsaber_ugly_fixes", function(ent)
		local class = ent:GetClass()
		if class == "weapon_lightsaber" or class == "lightsaber" then
			if class == "weapon_lightsaber" then
				lightsabers[ent] = true
			else
				lightsaber_ents[ent] = true
			end
		end
	end)

	hook.Add("Think", "lightsaber_ugly_fixes", function()
		for ent in pairs(lightsabers) do
			if !IsValid(ent) then
				lightsabers[ent] = nil
				continue
			end
			if (!IsValid(ent:GetOwner()) or ent:GetOwner():GetActiveWeapon() != ent or !ent.GetBladeLength or ent:GetBladeLength() <= 0) then continue end
			local pos, ang = ent:GetSaberPosAng()
			LS_ProcessEntity(ent:EntIndex(), pos, ang, ent:GetBladeLength())
			if (ent:LookupAttachment("blade2") > 0) then
				local pos2, ang2 = ent:GetSaberPosAng(2)
				LS_ProcessEntity(ent:EntIndex() + 655, pos2, ang2, ent:GetBladeLength())
			end
		end
		for ent in pairs(lightsaber_ents) do
			if !IsValid(ent) then
				lightsaber_ents[ent] = nil
				continue
			end
			if (!ent.GetBladeLength or ent:GetBladeLength() <= 0) then continue end
			local pos, ang = ent:GetSaberPosAng()
			LS_ProcessEntity(ent:EntIndex(), pos, ang, ent:GetBladeLength())
			if (ent:LookupAttachment("blade2") > 0) then
				local pos2, ang2 = ent:GetSaberPosAng(2)
				LS_ProcessEntity(ent:EntIndex() + 655, pos2, ang2, ent:GetBladeLength())
			end
		end
	end)
end