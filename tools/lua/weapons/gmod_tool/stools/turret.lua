if SERVER then
	CreateConVar("sbox_maxturrets", 2)
end

TOOL.Category = "Construction"
TOOL.Name = "#tool.turret.name"

TOOL.ClientConVar["key"] = "0"
TOOL.ClientConVar["delay"] = "0.1"
TOOL.ClientConVar["toggle"] = "0"
TOOL.ClientConVar["force"] = "1"
TOOL.ClientConVar["sound"] = "Weapon_SMG1.Single"
TOOL.ClientConVar["damage"] = "10"
TOOL.ClientConVar["spread"] = "0"
TOOL.ClientConVar["automatic"] = "1"
TOOL.ClientConVar["tracer"] = "Tracer"

cleanup.Register("turrets")

TOOL.Information = {
	{name = "left"}
}

if CLIENT then
	language.Add("tool.turret.name", "Geschütz")
	language.Add("tool.turret.desc", "Schießt Kugeln auf Geheiß")
	language.Add("tool.turret.left", "Geschütz erstellen/aktualisieren")
	language.Add("tool.turret.spread", "Kugelverbreitung")
	language.Add("tool.turret.force", "Kugelkraft")
	language.Add("tool.turret.sound", "Schußklang")
	language.Add("max_turrets", "Maximale Geschütze")
	language.Add("Undone_turret", "Undone Turret")
	language.Add("Cleanup_turrets", "Turrets")
	language.Add("Cleaned_turrets", "Cleaned up all Turrets")
	language.Add("SBoxLimit_turrets", "You've hit the Turretlimit!")
end

function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if IsValid(ent) and ent:IsPlayer() then return false end
	if SERVER and !util.IsValidPhysicsObject(ent, trace.PhysicsBone) then return false end
	if CLIENT then return true end
	local ply = self:GetOwner()
	local key = self:GetClientNumber("key") 
	local delay = self:GetClientNumber("delay") 
	delay = math.Clamp(delay, 0.1, 10)
	local toggle = self:GetClientNumber("toggle") == 1
	local force = self:GetClientNumber("force")
	force = math.Clamp(force, 0, 1000)
	local sound = self:GetClientInfo("sound")
	local tracer = self:GetClientInfo("tracer")
	local damage = self:GetClientNumber("damage")
	damage = math.Clamp(damage, 0, 10)
	local spread = self:GetClientNumber("spread")
	spread = math.Clamp(spread, 0, 1)
	local worldweld = true
	local numbullets = 1
	if (IsValid(ent) and ent:GetClass() == "turret" and ent.player == ply) then
		ent:SetDamage(damage)
		ent:SetDelay(delay)
		ent:SetToggle(toggle)
		ent:SetNumBullets(numbullets)
		ent:SetSpread(spread)
		ent:SetForce(force)
		ent:SetSound(sound)
		ent:SetTracer(tracer)
		numpad.Remove(ent.OnUp)
		numpad.Remove(ent.OnDown)
		numpad.OnDown(ply, key, "Turret_On", ent)
		numpad.OnUp(ply, key, "Turret_Off", ent)
		return true
	end
	if !self:GetSWEP():CheckLimit("turrets") then return false end
	if (ent != NULL and (!ent:IsWorld() or worldweld)) then
		trace.HitPos = trace.HitPos + trace.HitNormal * 2
	else
		trace.HitPos = trace.HitPos + trace.HitNormal * 2
	end
	local turret = MakeTurret(ply, trace.HitPos, nil, key, delay, toggle, damage, force, sound, numbullets, spread, tracer)
	if !IsValid(turret) then return end
	turret:SetAngles(trace.HitNormal:Angle())
	local weld
	if (ent != NULL) then
		if (!ent:IsWorld() or worldweld) then
			weld = constraint.Weld(turret, ent, 0, trace.PhysicsBone, 0, 0, true)
			turret:GetPhysicsObject():EnableCollisions(false)
			turret.nocollide = true
		else
			turret:GetPhysicsObject():Sleep()
		end
	end
	undo.Create("Turret")
		undo.AddEntity(turret)
		undo.AddEntity(weld)
		undo.SetPlayer(ply)
	undo.Finish()
	return true
end

if SERVER then
	function MakeTurret(ply, Pos, Ang, key, delay, toggle, damage, force, sound, numbullets, spread, tracer, Vel, aVel, frozen, nocollide)
		if IsValid(ply) and !ply:CheckLimit("turrets") then return false end
		local turret = ents.Create("turret")
		if !IsValid(turret) then return false end
		turret:SetPos(Pos)
		if A1ng then turret:SetAngles(Ang) end
		turret:Spawn()
		turret:SetDamage(damage)
		turret:SetPlayer(ply)
		turret:SetSpread(spread)
		turret:SetForce(force)
		turret:SetSound(sound)
		turret:SetTracer(tracer)
		turret:SetNumBullets(numbullets)
		turret:SetDelay(delay)
		turret:SetToggle(toggle)
		turret.OnDown = numpad.OnDown(ply, key, "Turret_On", turret)
		turret.OnUp = numpad.OnUp(ply, key, "Turret_Off", turret)
		if (nocollide == true) then turret:GetPhysicsObject():EnableCollisions(false) end
		local ttable = {
			key	= key,
			delay = delay,
			toggle = toggle,
			damage = damage,
			player = ply,
			nocollide = nocollide,
			force = force,
			sound = sound,
			spread = spread,
			numbullets = numbullets,
			tracer = tracer
		}
		table.Merge(turret:GetTable(), ttable)
		ply:AddCount("turrets", turret)
		ply:AddCleanup("turrets", turret)
		DoPropSpawnedEffect(turret)
		return turret
	end
	duplicator.RegisterEntityClass("turret", MakeTurret, "Pos", "Ang", "key", "delay", "toggle", "damage", "force", "sound", "numbullets", "spread", "tracer", "Vel", "aVel", "frozen", "nocollide")
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {Text = "#tool.turret.name", Description = "#tool.turret.desc"} )
	CPanel:AddControl("ComboBox", {MenuButton = 1, Folder = "turret", Options = {["#preset.default"] = ConVarsDefault}, CVars = table.GetKeys(ConVarsDefault)})
	CPanel:AddControl("Numpad", {Label = "Aktivieren", Command = "turret_key", ButtonSize = 22})
	local weaponSounds = {Label = "#tool.turret.sound", MenuButton = 0, Options = {}, CVars = {}}
	weaponSounds["Options"]["Kein Ton"] = {turret_sound = ""}
	weaponSounds["Options"]["Pistole"] = {turret_sound = "Weapon_Pistol.Single"}
	weaponSounds["Options"]["SMG1"] = {turret_sound = "Weapon_SMG1.Single"}
	weaponSounds["Options"]["Gewehr"] = {turret_sound = "Weapon_AR2.Single"}
	weaponSounds["Options"]["Schrotflinte"] = {turret_sound = "Weapon_Shotgun.Single"}
	weaponSounds["Options"]["Bodengeschütz"] = {turret_sound = "NPC_FloorTurret.Shoot"}
	CPanel:AddControl("ComboBox", weaponSounds)
	local TracerType = {Label = "Schuss", MenuButton = 0, Options={}, CVars = {}}
	TracerType["Options"]["Standardmäßig"] = {turret_tracer = "Tracer"}
	TracerType["Options"]["Gewehr"] = {turret_tracer = "AR2Tracer"}
	TracerType["Options"]["Geschütz"] = {turret_tracer = "AirboatGunHeavyTracer"}
	TracerType["Options"]["Laser"]	= {turret_tracer = "LaserTracer"}
	TracerType["Options"]["Keine Spur"] = {turret_tracer = ""}
	CPanel:AddControl("ComboBox", TracerType)
	CPanel:AddControl("Slider", {Label = "Schaden", Type = "Float", Min = 0, Max = 10, Command = "turret_damage"}	)
	CPanel:AddControl("Slider", {Label = "#tool.turret.spread", Type = "Float", Min = 0, Max = 1, Command = "turret_spread"}	)
	CPanel:AddControl("Slider", {Label = "#tool.turret.force", Type = "Float", Min = 0, Max = 1000, Command = "turret_force"}	)
	CPanel:AddControl("Slider", {Label = "Verzögerung", Type = "Float", Min	= 0.1, Max = 10, Command = "turret_delay"} )
	CPanel:AddControl("Checkbox", {Label = "Umschalten", Command = "turret_toggle"})
end