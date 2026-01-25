TOOL.AllowedClasses = {
	prop_physics = true,
	prop_physics_multiplayer = true,
	prop_ragdoll = true,
	prop_effect = true,
	prop_vehicle = true,
	prop_vehicle_jeep = true,
	prop_vehicle_jeep_old = true,
	prop_vehicle_airboat = true,
	prop_vehicle_prisoner_pod = true
}

TOOL.AllowedBaseClasses = {
	base_anim = true,
	base_entity = true,
	base_gmodentity = true
}

TOOL.Category = "Constraints"
TOOL.Name = "Einfaches Verbinden"
TOOL.ClientConVar["selectradius"] = 100
TOOL.ClientConVar["nocollide"] = 1
TOOL.ClientConVar["freeze"] = 0
TOOL.ClientConVar["clearwelds"]	= 1
TOOL.ClientConVar["strength"] = 0
TOOL.ClientConVar["world"] = 0
TOOL.ClientConVar["maxweldsperprop"] = 10
TOOL.ClientConVar["color_r"] = 0
TOOL.ClientConVar["color_g"] = 255
TOOL.ClientConVar["color_b"] = 0
TOOL.ClientConVar["color_a"] = 255
TOOL.SelectedProps = {}

TOOL.Information = {
	{name = "left"},
	{name = "leftuse"},
	{name = "right", stage = 2},
	{name = "rightuse", stage = 2},
	{name = "reload", stage = 2}
}

cleanup.Register("smartweld")

if CLIENT then
	language.Add("tool.smartweld.name", "Einfaches Verbinden")
	language.Add("tool.smartweld.desc", "Verbindet automatisch ausgewählte Props.")
	language.Add("tool.smartweld.left", "Wähle ein Prop aus oder entferne es aus der Auswahl")
	language.Add("tool.smartweld.leftuse", "Wähle Props in einem bestimmten Radius automatisch aus")
	language.Add("tool.smartweld.right", "Verbinde ausgewählte Props")
	language.Add("tool.smartweld.rightuse", "Verbinde alle Props an das Prop auf das du derzeitig schaust")
	language.Add("tool.smartweld.reload", "Setze die derzeitige Auswahl zurück")
	language.Add("tool.smartweld.selectoutsideradius", "Auswahlradius:")
	language.Add("tool.smartweld.selectoutsideradius.help", "Alle Props in diesem Radius werden automatisch ausgewählt.")
	language.Add("tool.smartweld.maxweldsperprop", "Maximale Verbindungen pro Prop")
	language.Add("tool.smartweld.maxweldsperprop.help", "Diese Funktion bewirkt nur etwas, wenn mindestens 64 Props gleichzeitig verbunden werden.\nEs ist hierbei nicht schlau über 10 zu gehen.")
	language.Add("tool.smartweld.world", "Alles an Welt verbinden")
	language.Add("tool.smartweld.world.help", "Verbindet alles mit der Welt.\nSinnvoll, wenn Props sich nicht vom Fleck bewegen sollen.")
	language.Add("tool.smartweld.nocollide", "Keine Kollision")
	language.Add("tool.smartweld.nocollide.help", "Deaktiviert die Kollision aller Props miteinander.")
	language.Add("tool.smartweld.freeze", "Automatisches Einfrieren")
	language.Add("tool.smartweld.freeze.help", "Friert alle Props automatisch ein.")
	language.Add("tool.smartweld.clearwelds", "Alte Verbindungen entfernen")
	language.Add("tool.smartweld.clearwelds.help", "Sollten ausgewählte Props derzeitig existierende Verbindungen haben, werden diese automatisch entfernt.")
	language.Add("tool.smartweld.color", "Auswahlfarbe")
	language.Add("tool.smartweld.color.help", "Ändert die Farbe ausgewählter Props.")
	language.Add("Undone_smartweld", "Undone Quick Weld")
	language.Add("Cleanup_smartweld", "Quick Welds")
	language.Add("Cleaned_smartweld", "Cleaned up all Quick Welds")
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(panel)
	panel:SetName("Einfaches Verbinden")
	panel:AddControl("Header", {Text = "", Description = "Verbindet automatisch ausgewählte Props."})
	panel:AddControl("ComboBox", {MenuButton = 1, Folder = "smartweld", Options = {["#preset.default"] = ConVarsDefault}, CVars = table.GetKeys(ConVarsDefault)})
	panel:AddControl("Slider", {Label = "#tool.smartweld.selectoutsideradius", Help = "#tool.smartweld.selectoutsideradius", Type = "float", Min = "0", Max = "1000", Command = "smartweld_selectradius"})
	panel:AddControl("Slider", {Label = "#tool.forcelimit", Help = true, Type = "float", Min = "0", Max = "10000", Command = "smartweld_strength"})
	panel:AddControl("Slider", {Label = "#tool.smartweld.maxweldsperprop", Help = "#tool.smartweld.maxweldsperprop", Type = "Integer", Min = "1", Max = "10", Command = "smartweld_maxweldsperprop"})
	panel:AddControl("Checkbox", {Label = "#tool.smartweld.world", Help = "#tool.smartweld.world", Command = "smartweld_world"})
	panel:AddControl("Checkbox", {Label = "#tool.smartweld.nocollide", Help = "#tool.smartweld.nocollide", Command = "smartweld_nocollide"})
	panel:AddControl("Checkbox", {Label = "#tool.smartweld.freeze", Help = "#tool.smartweld.freeze", Command = "smartweld_freeze"})
	panel:AddControl("Checkbox", {Label = "#tool.smartweld.clearwelds", Help = "#tool.smartweld.clearwelds", Command = "smartweld_clearwelds"})
	panel:AddControl("Color", {Label = "#tool.smartweld.color", Help = "#tool.smartweld.color", Red = "smartweld_color_r", Green = "smartweld_color_g", Blue = "smartweld_color_b", Alpha = "smartweld_color_a"})
end

local ipairs = ipairs
local IsValid = IsValid
local Weld = constraint.Weld
local AddEntity = undo.AddEntity
local Cleanup = cleanup.Add

function TOOL:Holster()
	if CLIENT or game.SinglePlayer() then
		for _,v in ipairs(self.SelectedProps) do
			if IsValid(v.ent) then
				v.ent:SetColor(v.col)
			end
		end
	end
	self.SelectedProps = {}
	self:SetStage(1)
end

function TOOL:LeftClick(tr)
	local ent = tr.Entity
	if IsValid(ent) and !ent:IsPlayer() then
		if self:GetOwner():KeyDown(IN_USE) then return
			self:AutoSelect(ent)
		end
		if SERVER and !util.IsValidPhysicsObject(ent, tr.PhysicsBone) then return false end
		if IsFirstTimePredicted() then
			self:HandleProp(tr)
		end
		return true
	end
	return false
end

function TOOL:AutoSelect(ent)
	if !IsValid(ent) then return false end
	local preAutoSelect = #self.SelectedProps
	local selectRadius = self:GetClientNumber("selectradius")
	local radiusProps = ents.FindInSphere(ent:GetPos(), selectRadius)
	if #radiusProps < 1 then return false end
	local numNearProps = 0
	for i = 1, #radiusProps do
		if self:IsAllowedEnt(ent) and !self:PropHasBeenSelected(radiusProps[i]) then
			self:SelectProp(radiusProps[i])
			numNearProps = numNearProps + 1
		end
	end
	if CLIENT and IsFirstTimePredicted() then
		self:GetOwner():ChatPrint(#self.SelectedProps-preAutoSelect.." Prop(s) wurde(n) automatisch ausgewählt.")
	end
end

function TOOL:HandleProp(tr)
	local ent = tr.Entity
	if #self.SelectedProps == 0 then
		self:SelectProp(ent, tr.PhysicsBone)
	else
		for _,v in ipairs(self.SelectedProps) do
			if v.ent == ent then
				self:DeselectProp(ent)
				return true
			end
		end
		self:SelectProp(ent, tr.PhysicsBone)
	end
	return true
end

function TOOL:DeselectProp(ent)
	for k,v in ipairs(self.SelectedProps) do
		if v.ent == ent then
			if CLIENT or game.SinglePlayer() then
				ent:SetColor(v.col)
			end
			table.remove(self.SelectedProps, k)
			break
		end
	end
	return true
end

function TOOL:SelectProp(entity, hitBoneNum)
	if self:IsAllowedEnt(entity) then
		if #self.SelectedProps == 0 then
			self:SetStage(2)
		end
		local boneNum = entity:IsRagdoll() and hitBoneNum or 0
		table.insert(self.SelectedProps, {ent = entity, col = entity:GetColor(), bone = boneNum})
		if CLIENT or game.SinglePlayer() then
			entity:SetColor(Color(self:GetClientNumber("color_r", 0), self:GetClientNumber("color_g", 0), self:GetClientNumber("color_b", 0), self:GetClientNumber("color_a", 255)))
		end
		return true
	end
	return false
end

function TOOL:RightClick(tr)
	if #self.SelectedProps <= 1 then
		if CLIENT and IsFirstTimePredicted() then
			self:GetOwner():ChatPrint((#self.SelectedProps == 1 and "Wähle mindestens ein weiteres Prop aus!" or "Kein Prop ausgewählt!"))
		end
		return false
	end
	if SERVER then
		undo.Create("smartweld")
			self:PreWeld()
			self:PerformWeld(tr)	
			undo.SetPlayer(self:GetOwner())
		undo.Finish()
	end
	self:FinishWelding(tr.Entity)
	return true
end

function TOOL:PreWeld()
	local freezeProps = self:GetClientNumber("freeze")
	local removeOldWelds = self:GetClientNumber("clearwelds")
	for _,v in ipairs(self.SelectedProps) do
		if IsValid(v.ent) then
			if removeOldWelds == 1 then
				constraint.RemoveConstraints(v.ent, "Weld") 
			end
			if freezeProps == 1 then
				local physobj = v.ent:GetPhysicsObject()
				if IsValid(physobj) then
					physobj:EnableMotion(false)
					self:GetOwner():AddFrozenPhysicsObject(v.ent, physobj)
				end
			end
		end
	end
end

function TOOL:PerformWeld(tr)
	local weldToWorld = tobool(self:GetClientNumber("world"))
	local nocollide = tobool(self:GetClientNumber("nocollide"))
	local weldForceLimit = math.floor(self:GetClientNumber("strength"))
	local ply = self:GetOwner()
	if #self.SelectedProps < 2 then return end
	if weldToWorld then
		local world = game.GetWorld()
		for _,v in ipairs(self.SelectedProps) do
			local weld = Weld(v.ent, world, 0, 0, weldForceLimit, nocollide, false)
			if weld then
				undo.AddEntity(weld)
				Cleanup(ply, "smartweld", weld)
			end
		end
	elseif self:GetOwner():KeyDown(IN_USE) then
		for _,v in ipairs(self.SelectedProps) do
			local weld = Weld(v.ent, tr.Entity, v.bone, tr.PhysicsBone, weldForceLimit, nocollide, false)
			if weld then
				undo.AddEntity(weld)
				Cleanup(ply, "smartweld", weld)
			end
		end
	elseif #self.SelectedProps < 64 then
		for i = 1, #self.SelectedProps do
			local firstprop = self.SelectedProps[i]
			for k = i+1, #self.SelectedProps do
				local secondprop = self.SelectedProps[k]
				if IsValid(firstprop.ent) and IsValid(secondprop.ent) then
					local weld = Weld(firstprop.ent, secondprop.ent, firstprop.bone, secondprop.bone, weldForceLimit, nocollide, false)
					if weld then
						undo.AddEntity(weld)
						Cleanup(ply, "smartweld", weld)
					end
				end
			end
		end
	else
		local function AreLinked(prop_one, prop_two)
			return self.SelectedProps[prop_two][prop_one] == true or self.SelectedProps[prop_one][prop_two] == true
		end
		local function LinkProps(id_one, prop_one, id_two)
			local weld = Weld(prop_one.ent, self.SelectedProps[id_two].ent, 0, 0, weldForceLimit, nocollide, false)
			if weld then
				undo.AddEntity(weld)
				Cleanup(ply, "smartweld", weld)
			end
			self.SelectedProps[id_one][id_two] = true
			self.SelectedProps[id_two][id_one] = true
		end
		local maxweldsperprop = math.min(self:GetClientNumber("maxweldsperprop"), 10)
		for i,v in ipairs(self.SelectedProps) do
			self.SelectedProps[i][i] = true
			for _ = 1, maxweldsperprop do
				local closestdistance = math.huge
				local closestprop_id = -1
				for j,d in ipairs(self.SelectedProps) do
					if !AreLinked(i, j) then
						local distance = (v.ent:GetPos() - d.ent:GetPos()):LengthSqr()
						if distance < closestdistance then
							closestdistance = distance
							closestprop_id = j
						end
					end
				end
				if closestprop_id != -1 then
					LinkProps(i, v, closestprop_id)
				end
			end
		end
	end
end

function TOOL:FinishWelding(entity)
	if !IsFirstTimePredicted() then return end
	if CLIENT then
		local numProps = 0
		for _,v in ipairs(self.SelectedProps) do
			if IsValid(v.ent) then
				v.ent:SetColor(v.col)
				numProps = numProps + 1
			end
		end
		if self:GetOwner():KeyDown(IN_USE) then
			if !self:PropHasBeenSelected(entity) then
				numProps = numProps + 1
			end
			self:GetOwner():ChatPrint("Verbinden erfolgreich! "..numProps.." Props wurden an ein Prop verbunden.")
		elseif tobool(self:GetClientNumber("world")) then
			self:GetOwner():ChatPrint("Verbinden erfolgreich! "..numProps.." Props wurden mit der Welt verbunden.")
		else
			self:GetOwner():ChatPrint("Verbinden erfolgreich! "..numProps.." Props wurden mit einander verbunden.")
		end
	end
	self.SelectedProps = {}
	self:SetStage(1)
end

function TOOL:PropHasBeenSelected(ent)
	for _, v in ipairs(self.SelectedProps) do
		if ent == v.ent then
			return true
		end
	end
	return false
end

function TOOL:Reload()
	if self.SelectedProps and #self.SelectedProps > 0 then
		if CLIENT and IsFirstTimePredicted() then
			self:GetOwner():ChatPrint("Auswahl zurückgesetzt.")
		end
		if IsFirstTimePredicted() then
			self:Holster()
		end
		return true
	end
	return false
end

function TOOL:IsAllowedEnt(ent)
	if IsValid(ent) then
		local ply = SERVER and self:GetOwner() or self.Owner
		local class = ent:GetClass()
		local tr = ply:GetEyeTrace()
		if FPP and FPP.plyCanTouchEnt and !FPP.plyCanTouchEnt(ply, ent, "Toolgun") or (ent.CPPICanTool and !ent:CPPICanTool(ply, "smartweld")) or (!self.AllowedBaseClasses[ent.Base] and !self.AllowedClasses[class]) then
			return false
		end
		return true
	end
	return false
end