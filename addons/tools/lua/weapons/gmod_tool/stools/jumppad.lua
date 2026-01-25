if SERVER then
	CreateConVar("sbox_maxjumppads", 2)
end

TOOL.Category = "Build & Fight"
TOOL.Name = "Jump Pads"

TOOL.ClientConVar["hightadd" ] = 1
TOOL.ClientConVar["r"] = 255
TOOL.ClientConVar["g"] = 170
TOOL.ClientConVar["b"] = 0
TOOL.ClientConVar["a"] = 255
TOOL.ClientConVar["nofalldamage"] = "1"
TOOL.ClientConVar["soundname"] = "HV_Jump_pad_launch.wav"
TOOL.ClientConVar["effect"] = "hv_jumppadfx"

TOOL.Information = {
	{name = "left", stage = 0},
	{name = "left_1", stage = 1}
}

if SERVER then
	function MakeJumppad(ply, ang, pos, z_modifier, nofalldmg, effect_col, soundname, effectname, targetent, target_name, targetpos, targettype)
		if IsValid(ply) and !ply:CheckLimit("jumppads") then return false end
		local jumppad = ents.Create("jumppad")
		if !IsValid(jumppad) then return false end
		jumppad:SetModel("models/highvoltage/ut2k4/pickups/jump_pad.mdl")
		jumppad:SetAngles(ang)
		jumppad:SetPos(pos)
		jumppad:Spawn()
		jumppad:Activate()
		local phys = jumppad:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
		if ply then
			jumppad:SetPlayer(ply)
		end
		if z_modifier then
			jumppad:SetHeightAdd(z_modifier)
		end
		if nofalldmg then
			jumppad:SetNoFallDamage(nofalldmg)
		end
		if effect_col then
			jumppad:SetEffectColor(effect_col)
		end
		if soundname then
			jumppad:SetSoundName(soundname)
		end
		if effectname then
			jumppad:SetEffectName(effectname)
		end
		if targetent then
			jumppad:SetTargetEnt(targetent)
		end
		if target_name then
			jumppad:SetTargetName(target_name)
		end
		if targetpos then
			jumppad:SetTargetPos(targetpos)
		end
		if targettype then
			jumppad:SetTargetType(targettype)
		end
		local ttable = {
			ply	= ply
		}
		table.Merge(jumppad:GetTable(), ttable)
		if IsValid(ply) then
			ply:AddCount("jumppads", jumppad)
		end
		DoPropSpawnedEffect(jumppad)
		return jumppad
	end

	local function Jumppad_Randomize(pl, command, arguments)
		local m = {}
		for k, v in SortedPairs(list.Get("JumpPadModels")) do
			table.insert(m, k)
		end
		local col = HSVToColor(math.random(1,360), math.Clamp(math.Rand(0.5,1.5),0.5,1), math.Clamp(math.Rand(0.75,1.5),0.5,1))
		pl:ConCommand("jumppad_r "..col.r)
		pl:ConCommand("jumppad_g "..col.g)
		pl:ConCommand("jumppad_b "..col.b)
		pl:ConCommand("jumppad_a "..col.a)
		local s = {}
		for k, v in SortedPairs(list.Get("LaunchSounds")) do
			table.insert(s, v.jumppad_soundname)
		end
		pl:ConCommand("jumppad_soundname "..table.Random(s))
		local e = {}
		for k, v in SortedPairs(list.Get("JumpPadEffects")) do
			table.insert(e, v.jumppad_effect)
		end
		pl:ConCommand("jumppad_effect "..table.Random(e))
		pl:ConCommand("jumppad_hightadd "..math.Rand(0.75,3))
	end
	concommand.Add("jumppad_randomize", Jumppad_Randomize)
end

if CLIENT then
	language.Add("tool.jumppad.name", "Jump Pad")
	language.Add("tool.jumppad.left", "Jump Pad erstellen")
	language.Add("tool.jumppad.left_1", "Landeposition bestimmen")
	language.Add("tool.jumppad.desc", "Erstelle Jump Pads und koordiniere dann ihre Landeposition.")
	language.Add("tool.jumppad.hightadd", "Höhe")
	language.Add("tool.jumppad.hightadd.help", "Dies ist der Multiplikator für die Höhe der Katapultation durch das Jump Pad.")
	language.Add("tool.jumppad.color", "Die Farbe des Effekts")
	language.Add("tool.jumppad.falldmg", "Fallschaden deaktivieren")
	language.Add("tool.jumppad.falldmg.help", "Verhindert Fallschaden durch Jump Pads verursacht.")
	language.Add("tool.jumppad.effect", "Effekt")
	language.Add("Cleaned_jumppads", "Cleaned up all Jump Pads")
	language.Add("Cleanup_jumppads", "Jump Pads")
	language.Add("Undone_Jump Pad", " Undone Jump Pad")
	language.Add("SBoxLimit_jumppads", "You've hit the Jump Pads limit")
	language.Add("max_jumppads", "Maximale Jump Pads")
	language.Add("jumppad_off", "Jump Pad deaktivieren")
	language.Add("jumppad_on", "Jump Pad aktivieren")
	language.Add("jumppad_hidepath", "Sprungpfad verstecken")
	language.Add("jumppad_showpath", "Sprungpfad anzeigen")
	language.Add("jumppadsounds.default", "Standardmäßig")
	language.Add("jumppadsounds.nothing", "Keinen Sound")
	language.Add("jumppadsounds.gunship", "Luftschiff")
	language.Add("jumppadsounds.cannisterlaunch", "Headcrabkannister-Start")
	language.Add("jumppadsounds.combinemine", "Landmine")
	language.Add("jumppadsounds.rolermine", "Rollermine")
	language.Add("jumppadsounds.striderfire", "Strider-Beschuss")
	language.Add("jumppadsounds.airboatenergy", "Luftschiff-Energie")
	language.Add("jumppadsounds.ar2altfire", "AR2 Sekundärfeuer")
	language.Add("jumppadsounds.crossbow", "Jagdbogen")
	language.Add("jumppadsounds.physcannon", "Physikkannone")
	language.Add("jumppadeffects.dots", "Standardmäßig")
	language.Add("jumppadeffects.streaks", "Striche")
	language.Add("jumppadeffects.bubbles", "Blubberblasen")
end

cleanup.Register("jumppads")

function TOOL:LeftClick(trace)
	if self:GetStage() == 0 then
		local ent = trace.Entity
		if (IsValid(ent) and ent:IsPlayer()) then return false end
		if CLIENT then return true end
		if !util.IsValidPhysicsObject(ent, trace.PhysicsBone) then return false end
		local ply = self:GetOwner()
		local hightadd = self:GetClientNumber("hightadd")
		local r = self:GetClientNumber("r") 
		local g = self:GetClientNumber("g")
		local b = self:GetClientNumber("b")
		local a = self:GetClientNumber("a")
		local color = Vector(r,g,b)/255
		local nofalldmg = self:GetClientNumber("nofalldamage") == 1
		local soundname = self:GetClientInfo("soundname")
		local effectname = self:GetClientInfo("effect")
		if (IsValid(ent) and ent:GetClass() == "jumppad" and ent:GetPlayer() == ply) then
			ent:SetHeightAdd(hightadd)
			ent:SetNoFallDamage(nofalldmg)
			ent:SetEffectColor(color)
			ent:SetSoundName(soundname)
			ent:SetEffectName(effectname)
			return true, NULL, true
		end
		if !self:GetSWEP():CheckLimit("jumppads") then return false end
		local Ang = trace.HitNormal:Angle()
		Ang.pitch = Ang.pitch + 90
		local jumppad = MakeJumppad(ply, Ang, trace.HitPos, hightadd, nofalldmg, color, soundname, effectname)
		if !IsValid(jumppad) then return end
		local min = jumppad:GetCollisionBounds()
		jumppad:SetPos(trace.HitPos - trace.HitNormal * min.z)
		undo.Create("Jump Pad")
			undo.AddEntity(jumppad)
			undo.SetPlayer(ply)
		undo.Finish()
		ply:AddCleanup("jumppads", jumppad)
		self.Weapon:SetNW2Entity("CurJumppad", jumppad)
		self:SetStage(1)
		return true, jumppad
	else
		self:SetStage(0)
		local jumppad = self.Weapon:GetNW2Entity("CurJumppad")
		if !IsValid(jumppad) then return false end
		if jumppad.SetTargetPos then
			jumppad:SetTargetPos(trace.HitPos)
		end
		self.Weapon:SetNW2Entity("CurJumppad", NULL)
		return true
	end
end

if CLIENT then 
	local mat = Material("vgui/circle")
	local mat2 = Material("sprites/ut2k4/flashflare1")
	local col = Color(255, 170, 0, 255)
	local height = 1
	local getcol = CurTime() + 0.1

	local function GetVelo(pos, pos2, time)
		local diff = pos - pos2
		local velx = diff.x/time
		local vely = diff.y/time
		local velz = (diff.z - 0.5 * -GetConVar("sv_gravity"):GetInt() * (time ^ 2)) / time 
		return Vector(velx, vely, velz)
	end	
		
	local function LaunchArc(pos, pos2, time, t)
		local v = GetVelo(pos, pos2, time).z
		local a = -GetConVar("sv_gravity"):GetInt()
		local z = v * t + 0.5 * a * t ^ 2
		local diff = pos - pos2
		local x = diff.x * (t / time)
		local y = diff.y * (t / time)
		return pos2 + Vector(x, y, z)
	end
	
	local function tehcol(num)
		return num == 1 and Color(240, 240, 240) or col
	end
	
	local function DrawJumpPadTarget(start, height, color, target, normal)
		local size = (math.sin(CurTime() * 3) * 8) + 32
		render.SetMaterial(mat)
		render.DrawQuadEasy(target + normal, normal, size, size, Color(240, 240, 240), (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 1.35, size / 1.35, color, (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 2, size / 2, Color(240, 240, 240), (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 3.5, size / 3.5, color, (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 8, size / 8, Color(240, 240, 240), (CurTime() * 50) % 360)
		local size = 9
		local segs = math.Clamp(math.Round(target:DistToSqr(start)/(40 * 40)), 8, 80)
		local count = 0
		local scroll = (CurTime() * -4)
		render.SetMaterial(mat2)
		render.StartBeam(segs + 2)
		render.AddBeam(start, size, scroll, tehcol(count%2))
		local lastpos = start
		for i = 0, segs, 1 do
			count = count + 1
			local frac = i/segs
			local pos = LaunchArc(target, start, height, height * frac)
			local len = lastpos:Distance(pos) / 12
			scroll = scroll + len
			lastpos = pos
			render.AddBeam(pos, size, scroll, tehcol(count%2))
		end
		count = count + 1
		scroll = scroll + (lastpos:Distance(target)) / 12
		render.AddBeam(target, size, scroll, tehcol(count%2))
		render.EndBeam()
	end

	local function DrawJumppadLandingPos(depth, sky)
		if sky then return end
		local ply = LocalPlayer()
		if ply:Alive() then
			local wep = ply:GetActiveWeapon()
			if wep:IsValid() and wep.GetMode and (wep:GetMode() == "jumppad") and (wep:GetStage() == 1) then
				if (getcol < CurTime()) then
					local tool = wep:GetToolObject()
					local r = tool:GetClientNumber("r") 
					local g = tool:GetClientNumber("g")
					local b = tool:GetClientNumber("b")
					local a = tool:GetClientNumber("a")
					height = tool:GetClientNumber("hightadd")
					col = Color(r, g, b, 255)
				end
				local jumppad = wep:GetToolObject().Weapon:GetNW2Entity("CurJumppad")
				if !IsValid(jumppad) then return end
				start = jumppad:GetPos()
				local tr = ply:GetEyeTrace()
				if !tr.HitPos then return end
				DrawJumpPadTarget(start, height, col, tr.HitPos, tr.HitNormal)
			end
		end
	end

	hook.Add("PostDrawTranslucentRenderables", "JumpPad_DrawJumppadLandingPos", DrawJumppadLandingPos)
end

function TOOL:UpdateGhostButton(ent, player)
	if !IsValid(ent) then return end
	local tr = util.GetPlayerTrace(player)
	local trace = util.TraceLine(tr)
	if !trace.Hit then return end
	local ent2 = trace.Entity
	if (IsValid(ent2) and ent2:GetClass() == "jumppad" or ent2:IsPlayer() or self:GetStage() == 1) then
		ent:SetNoDraw(true)
		return
	end
	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch + 90
	local min = ent:GetCollisionBounds()
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
	ent:SetAngles(ang)
	ent:SetNoDraw(false)
end

function TOOL:Think()
	if !IsValid(self.GhostEntity) then
		self:MakeGhostEntity("models/highvoltage/ut2k4/pickups/jump_pad.mdl", Vector(0, 0, 0), Angle(0, 0, 0))
	end
	self:UpdateGhostButton(self.GhostEntity, self:GetOwner())
	if self:GetStage() == 1 and (self.NextJumpPadUpdate or 0) < CurTime() then
		self.NextJumpPadUpdate = CurTime() + 0.1
		local jumppad = self.Weapon:GetNW2Entity("CurJumppad")
		if !IsValid(jumppad) or !jumppad.SetTargetPos then
			self:SetStage(0)
			return false
		end
		jumppad:SetTargetPos(self:GetOwner():GetEyeTrace().HitPos)
		local hightadd = self:GetClientNumber("hightadd")
		local r = self:GetClientNumber("r") 
		local g = self:GetClientNumber("g")
		local b = self:GetClientNumber("b")
		local a = self:GetClientNumber("a")
		local color = Vector(r,g,b) / 255
		local nofalldmg = self:GetClientNumber("nofalldamage") == 1
		local soundname = self:GetClientInfo("soundname")
		local effectname = self:GetClientInfo("effect")
		jumppad:SetHeightAdd(hightadd)
		jumppad:SetNoFallDamage(nofalldmg)
		jumppad:SetEffectColor(color)
		jumppad:SetSoundName(soundname)
		jumppad:SetEffectName(effectname)
	end
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", { Description = "#tool.jumppad.desc" })
	CPanel:AddControl("ComboBox", { MenuButton = 1, Folder = "jumppad", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys(ConVarsDefault) })
	CPanel:AddControl("Slider", { Label = "#tool.jumppad.hightadd", Command = "jumppad_hightadd", Type = "Float", Min = 0.1, Max = 3, Help = true })
	CPanel:AddControl("Color", { Label = "#tool.jumppad.color", Red = "jumppad_r", Green = "jumppad_g", Blue = "jumppad_b", Alpha = "jumppad_a" })
	CPanel:AddControl("CheckBox", { Label = "#tool.jumppad.falldmg", Command = "jumppad_nofalldamage", Help = true })
	CPanel:AddControl("ComboBox", { Label = "#tool.thruster.sound", Options = list.Get("LaunchSounds") })
	CPanel:AddControl("ComboBox", { Label = "#tool.jumppad.effect", Options = list.Get("JumpPadEffects") })
	CPanel:AddControl("Button", { Text = "#tool.faceposer.randomize", Command = "jumppad_randomize" })
end

list.Set("LaunchSounds", "#jumppadsounds.default", { jumppad_soundname = "HV_Jump_pad_launch.wav" })
list.Set("LaunchSounds", "#jumppadsounds.nothing", { jumppad_soundname = "" })
list.Set("LaunchSounds", "#jumppadsounds.gunship", { jumppad_soundname = "npc/combine_gunship/attack_start2.wav" })
list.Set("LaunchSounds", "#jumppadsounds.cannisterlaunch", { jumppad_soundname = "npc/env_headcrabcanister/launch.wav" })
list.Set("LaunchSounds", "#jumppadsounds.combinemine", { jumppad_soundname = "npc/roller/mine/rmine_blip3.wav" })
list.Set("LaunchSounds", "#jumppadsounds.rolermine", { jumppad_soundname = "npc/roller/mine/rmine_explode_shock1.wav" })
list.Set("LaunchSounds", "#jumppadsounds.striderfire", { jumppad_soundname = "npc/strider/fire.wav" })
list.Set("LaunchSounds", "#jumppadsounds.airboatenergy", { jumppad_soundname = "Airboat.FireGunHeavy" })
list.Set("LaunchSounds", "#jumppadsounds.ar2altfire", { jumppad_soundname = "weapons/ar2/npc_ar2_altfire.wav" })
list.Set("LaunchSounds", "#jumppadsounds.crossbow", { jumppad_soundname = "weapons/crossbow/fire1.wav" })
list.Set("LaunchSounds", "#jumppadsounds.physcannon", { jumppad_soundname = "Weapon_PhysCannon.Launch" })

list.Set("JumpPadEffects", "#jumppadeffects.dots", { jumppad_effect = "hv_jumppadfx" })
list.Set("JumpPadEffects", "#jumppadeffects.streaks", { jumppad_effect = "hv_jumppadfx2" })
list.Set("JumpPadEffects", "#jumppadeffects.bubbles", { jumppad_effect = "hv_jumppadfx3" })