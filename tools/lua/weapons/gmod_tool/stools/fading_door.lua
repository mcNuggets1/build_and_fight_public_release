TOOL.Category = "Construction"
TOOL.Name = "Fading Door"

TOOL.ClientConVar["key"] = "0"
TOOL.ClientConVar["toggle"] = "0"
TOOL.ClientConVar["reversed"] = "0"
TOOL.ClientConVar["noeffect"] = "0"

local nokeyboard = CreateConVar("fading_door_nokeyboard", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Set to 1 to disable using fading doors with the keyboard")

TOOL.Information = {
	{name = "left"},
	{name = "right"}
}

if CLIENT then
	language.Add("tool.fading_door.name", "Fading Door")
	language.Add("tool.fading_door.desc", "Bei Spieleraktivierung verblasst ein Objekt und die Kollision wird deaktiviert.")
	language.Add("tool.fading_door.left", "Fading Door erstellen/aktualisieren")
	language.Add("tool.fading_door.right", "Fading Door entfernen")
	language.Add("Undone_Fading Door", "Undone Fading Door")

	local ConVarsDefault = TOOL:BuildConVarList()
	function TOOL:BuildCPanel()
		self:AddControl("Header", {Text = "#tool.fading_door.name", Description = "#tool.fading_door.desc"})
		self:AddControl("ComboBox", {MenuButton = 1, Folder = "fading_door", Options = {["#preset.default"] = ConVarsDefault}, CVars = table.GetKeys(ConVarsDefault)})
		self:AddControl("CheckBox", {Label = "Verblasst starten", Command = "fading_door_reversed"})
		self:AddControl("CheckBox", {Label = "Umschalten", Command = "fading_door_toggle"})
		self:AddControl("CheckBox", {Label = "Kein Effekt", Command = "fading_door_noeffect"})
		self:AddControl("Numpad", {Label = "Verblassen", ButtonSize = "22", Command = "fading_door_key"})
	end
end

function isTouchingEntity(ent, ent2)
	local pos = ent2:GetPos()
	local trace = {
		start = pos,
		endpos = pos,
		filter = function(hit)
			if hit == ent then
				return true
			end
		end
	}
	local old_group = ent:GetCollisionGroup()
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ent:SetNotSolid(false)
	local tr = util.TraceEntity(trace, ent2)
	ent:SetNotSolid(true)
	ent:SetCollisionGroup(old_group)
	if tr.Hit then
		return true
	end
	return false
end

local function checkForStuckingPlayers(ent)
	local center, radius, forbidden = ent:LocalToWorld(ent:OBBCenter()), ent:BoundingRadius(), false
	for _,v in ipairs(ents.FindInSphere(center, radius)) do
		if v:IsPlayer() and v:Alive() or v:IsVehicle() then
			if isTouchingEntity(ent, v) then
				forbidden = true
			end
		end
		if forbidden then break end
	end
	return forbidden
end

local function checkUsage(self, typ)
	if !self.fadeToggle then
		local pressed = self.usedFadingDoor
		self.usedFadingDoor = nil
		if typ == 1 then
			self.usedFadingDoor = true
		elseif typ == 2 and !pressed then
			return false
		end
	end
	return true
end

local function fadeActivate(self, typ)
	if self.fadeActive or self.removeFade then return end
	if checkUsage(self, typ) then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
		self.fadeActive = true
		self.fadeMaterial = self:GetMaterial()
		self.fadeColor = self:GetColor()
		self.fadeNoDraw = self:GetNoDraw()
		if self.noEffect then
			self:SetNoDraw(true)
		else
			self:SetMaterial("sprites/heatwave")
		end
		self:DrawShadow(false)
		self:SetNotSolid(true)
	end
end

local function unfadeProp(self)
	if !self.removeFade then return end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	self.removeFade = false
	self.fadeActive = false
	if self.noEffect then
		self:SetNoDraw(self.fadeNoDraw)
	else
		self:SetMaterial(self.fadeMaterial or "")
		self:SetColor(self.fadeColor or color_white)
	end
	self:DrawShadow(true)
	self:SetNotSolid(false)
end

local function retryDeactivate(self)
	if !self.removeFade then return end
	if checkForStuckingPlayers(self) then
		timer.Simple(1, function()
			if IsValid(self) and self.removeFade then
				retryDeactivate(self)
			end
		end)
	else
		unfadeProp(self)
	end
end

local close_delay = 2
local function fadeDeactivate(self, typ)
	if !self.fadeActive or self.removeFade then return end
	if checkUsage(self, typ) then
		self.removeFade = true
		timer.Simple((self.LastToggle and self.LastToggle + close_delay or 0) > CurTime() and self.LastToggle + close_delay - CurTime() or 0, function()
			if !IsValid(self) then return end
			if checkForStuckingPlayers(self) then
				timer.Simple(1, function()
					if IsValid(self) then
						retryDeactivate(self)
					end
				end)
			else
				unfadeProp(self)
			end
		end)
	end
end

local function fadeToggleActive(self, ply, typ)
	if (nokeyboard:GetBool() and !numpad.FromButton()) then
		if (ply.FadingDoorMessage or 0) <= CurTime() then
			ply:ChatPrint("Du kannst Fading Doors nicht mit der Tastatur öffnen!\nBenutze Knopf/Keypad dafür.")
			ply.FadingDoorMessage = CurTime() + 120
		end
		return
	end
	if self.fadeActive then
		self:fadeDeactivate(typ)
	else
		self.LastToggle = CurTime()
		self:fadeActivate(typ)
	end
end

local function onUp(ply, ent)
	if !SERVER or !IsValid(ent) or !ent.isFadingDoor or ent.fadeToggle then return end
	ent:fadeToggleActive(ply, 2)
end

if SERVER then
	numpad.Register("Fading Door onUp", onUp)
end

local function onDown(ply, ent)
	if !SERVER or !IsValid(ent) or !ent.isFadingDoor then return end
	ent:fadeToggleActive(ply, 1)
end

if SERVER then
	numpad.Register("Fading Door onDown", onDown)
end

local function onRemove(self)
	numpad.Remove(self.fadeUpNum)
	numpad.Remove(self.fadeDownNum)
end

local function removeFadingDoor(ply, ent)
	if ent.isFadingDoor then
		ent.isFadingDoor = false
		ent:SetNW2Bool("isFadingDoor", false)
		numpad.Remove(ent.fadeUpNum)
		numpad.Remove(ent.fadeDownNum)
		if ent.fadeActive then
			ent:fadeDeactivate()
		end
		if IsValid(ply) then
			ply:ChatPrint("Fading Door entfernt.")
		end
	elseif IsValid(ply) then
		ply:ChatPrint("Das ist keine Fading Door!")
	end
end

local function createFadingDoor(ply, ent, stuff)
	if ent.isFadingDoor then
		onRemove(ent)
	else
		ent.isFadingDoor = true
		ent:SetNW2Bool("isFadingDoor", true)
		ent.fadeActivate = fadeActivate
		ent.fadeDeactivate = fadeDeactivate
		ent.fadeToggleActive = fadeToggleActive
		ent:CallOnRemove("Fading Door", onRemove)
	end
	ent.fadeUpNum = numpad.OnUp(ply, stuff.key, "Fading Door onUp", ent)
	ent.fadeDownNum = numpad.OnDown(ply, stuff.key, "Fading Door onDown", ent)
	ent.fadeToggle = stuff.toggle
	ent.noEffect = stuff.noeffect
	ent.fadeMaterial = ent:GetMaterial()
	if stuff.reversed then
		ent:fadeActivate()
	end
	local function undoFade(undo, ent)
		removeFadingDoor(nil, ent)
	end
	undo.Create("Fading Door")
		undo.AddFunction(undoFade, ent)
		undo.SetPlayer(ply)
	undo.Finish()
end

function TOOL:LeftClick(tr)
	local ent = tr.Entity
	if IsValid(ent) and !ent:IsPlayer() and !ent:IsNPC() and !ent:IsVehicle() then
		if CLIENT then return true end
		local ply = self:GetOwner()
		createFadingDoor(ply, ent, {
			key = self:GetClientNumber("key");
			toggle = self:GetClientNumber("toggle") == 1;
			reversed = self:GetClientNumber("reversed") == 1;
			noeffect = self:GetClientNumber("noeffect") == 1;
		})
		ply:ChatPrint("Fading Door erstellt/aktualisiert.")
		return true
	else
		return false
	end
end

function TOOL:RightClick(tr)
	local ent = tr.Entity
	if IsValid(ent) and !ent:IsPlayer() and !ent:IsNPC() and !ent:IsVehicle() then
		if CLIENT then return true end
		removeFadingDoor(self:GetOwner(), ent)
		return true
	else
		return false
	end
end