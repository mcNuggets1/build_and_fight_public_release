TOOL.Category = "Build & Fight"
TOOL.Name = "#tool.scale.name"

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}

function TOOL:LeftClick(trace)
	local ent = trace.Entity
    if !IsValid(ent) or ent:IsPlayer() or !ent.GetModelScale or !ent:GetModelScale() then return false end
	if !SERVER then return true end
	ent:SetModelScale(math.min(ent:GetModelScale() * 1.25, 25), 1)
	return true
end

function TOOL:RightClick(trace)
	local ent = trace.Entity
    if !IsValid(ent) or ent:IsPlayer() or !ent.GetModelScale or !ent:GetModelScale() then return false end
	if !SERVER then return true end
	ent:SetModelScale(ent:GetModelScale() * 0.75, 1)
	return true
end

function TOOL:Reload(trace)
	local ent = trace.Entity
    if !IsValid(ent) or ent:IsPlayer() or !ent.GetModelScale or !ent:GetModelScale() then return false end
	if !SERVER then return true end
	ent:SetModelScale(1, 1)
	return true
end

if CLIENT then
	language.Add("tool.scale.name", "Größe")
	language.Add("tool.scale.desc", "Ändert die Größe von Gegenständen und NPCs.")
	language.Add("tool.scale.left", "Vergrößern")
	language.Add("tool.scale.right", "Verkleinern")
	language.Add("tool.scale.reload", "Zurücksetzen")
end

function TOOL:BuildCPanel()
	self:AddControl("Header", {Description = "#tool.scale.desc"})
end