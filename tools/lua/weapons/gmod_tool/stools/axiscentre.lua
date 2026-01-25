TOOL.Category = "Constraints"
TOOL.Name = "#tool.axiscentre.listname"

TOOL.ClientConVar["forcelimit"] = 0
TOOL.ClientConVar["torquelimit"] = 0
TOOL.ClientConVar["hingefriction"] = 0
TOOL.ClientConVar["nocollide"] = 0
TOOL.ClientConVar["moveprop"] = 0
TOOL.ClientConVar["rot2nd"] = 0

TOOL.Information = {
	{name = "left", stage = 0},
	{name = "left_1", stage = 1}
}

if CLIENT then
	language.Add("tool.axiscentre.name", "Zentrumachse")
	language.Add("tool.axiscentre.listname", "Zentrumachse")
	language.Add("tool.axiscentre.desc", "Props durch Massenzentrum wiegen.")
	language.Add("tool.axiscentre.left", "Erstes Prop auswählen")
	language.Add("tool.axiscentre.left_1", "Zweites zu bewegendes Prop auswählen")
	language.Add("tool.axiscentre.nocollide", "Keine Kollision zwischen den Props")
	language.Add("tool.axiscentre.rot2nd", "Rotierung des zweiten Props zulassen")
	language.Add("tool.axiscentre.moveprop", "Erstes Prop bewegen")
	language.Add("tool.axiscentre.desc", "Das gewöhnliche Achsenwerkzeug, welches aber das Massenzentrum als Ursprungspunkt der Achse nimmt.")
	language.Add("Undone_Axis Centre", "Undone Axis Centre")
end

function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if ent:IsPlayer() then return false end
	if SERVER and !util.IsValidPhysicsObject(ent, trace.PhysicsBone) then return false end
	local iNum = self:NumObjects()
	local Phys = ent:GetPhysicsObjectNum(trace.PhysicsBone)
	self:SetObject(iNum + 1, ent, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal)
	if iNum > 0 then
		if CLIENT then
			self:ClearObjects()
			return true
		end
		local ply = self:GetOwner()
		local forcelimit = self:GetClientNumber("forcelimit", 0)
		local torquelimit = self:GetClientNumber("torquelimit", 0)
		local nocollide = self:GetClientNumber("nocollide", 0)
		local friction = self:GetClientNumber("hingefriction", 0)
		local moveprop = self:GetClientNumber("moveprop", 0)
		local rot2nd = self:GetClientNumber("rot2nd", 0)
		local Ent1, Ent2  = self:GetEnt(1),	self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1), self:GetBone(2)
		local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)
		local WPos1, WPos2 = self:GetPos(1), self:GetPos(2)
		local Norm1, Norm2 = self:GetNormal(1),	self:GetNormal(2)
		local Phys1, Phys2 = self:GetPhys(1), self:GetPhys(2)
		if Ent1 == Ent2 then
			self:ClearObjects()
			ply:ChatPrint("Fehler: Gleicher Gegenstand ausgewählt.")
			return true
		end
		if moveprop == 1 and !Ent1:IsWorld() then			
			local TargetPos = WPos2 + Phys1:GetPos() - WPos1
			Phys1:SetPos(TargetPos)
			Phys1:EnableMotion(false)
			Phys1:Wake()
		end
		LPos1 = Phys1:GetMassCenter()
		if rot2nd == 0 then
			LPos2 = Phys2:WorldToLocal(Phys1:LocalToWorld(LPos1) + Norm1)
		else
			LPos2 = Phys2:WorldToLocal(Phys1:LocalToWorld(LPos1) + Norm2)
		end
		local constraint = constraint.Axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide)
		undo.Create("Axis Centre")
			undo.AddEntity(constraint)
			undo.SetPlayer(self:GetOwner())
		undo.Finish()
		ply:AddCleanup("constraints", constraint)
		ply:ChatPrint("Werkzeug: Zentrumachse erstellt.")
		Phys1:EnableMotion(false)
		self:ClearObjects()
	else
		self:SetStage(iNum + 1)
	end
	return true
end

function TOOL:Reload(trace)
	local ent = trace.Entity
	if !IsValid(ent) or ent:IsPlayer() then return false end
	if CLIENT then return true end
	self:SetStage(0)
	return constraint.RemoveConstraints(ent, "Axis")
end

function TOOL:Holster(trace)
	self:ClearObjects()	
end

function TOOL:RightClick(trace)
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(Panel)
	Panel:AddControl("Header", {Text = "#tool.axiscentre.name", Description	= "#tool.axiscentre.desc"})	
	Panel:AddControl("ComboBox", {
		MenuButton = 1,
		Folder = "axiscentre",
		Options = {
			["#preset.default"] = ConVarsDefault
		},
		CVars = table.GetKeys(ConVarsDefault)
	})
	Panel:AddControl("Slider", {
		Label = "#tool.forcelimit",
		Type = "Float",
		Min	= 0,
		Max	= 50000,
		Command = "axiscentre_forcelimit",
		Help = true
	})
	Panel:AddControl("Slider", {
		Label = "#tool.torquelimit",
		Type = "Float",
		Min	= 0,
		Max	= 50000,
		Command = "axiscentre_torquelimit",
		Help = true
	})
	Panel:AddControl("Slider", {
		Label = "#tool.hingefriction",
		Type = "Float",
		Min	= 0,
		Max	= 200,
		Command = "axiscentre_hingefriction",
		Help = true
	})
	Panel:AddControl("CheckBox", {Label = "#tool.axiscentre.nocollide", Description = "", Command = "axiscentre_nocollide"})
	Panel:AddControl("CheckBox", {Label = "#tool.axiscentre.moveprop", Description = "", Command = "axiscentre_moveprop"})
	Panel:AddControl("CheckBox", {Label = "#tool.axiscentre.rot2nd", Description = "", Command = "axiscentre_rot2nd"})
end