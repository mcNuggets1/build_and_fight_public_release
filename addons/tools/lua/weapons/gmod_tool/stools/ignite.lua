TOOL.Category = "Construction"
TOOL.Name = "#Tool.ignite.name"

TOOL.ClientConVar["length"] = 120
TOOL.ClientConVar["reach"] = 0

TOOL.Information = {
	{name = "left"},
	{name = "right"}
}

if CLIENT then
	language.Add("tool.ignite.name", "Anzünden")
	language.Add("tool.ignite.desc", "Hiermit kann etwas in Brand gesteckt werden.")
	language.Add("tool.ignite.left", "Gegenstand anzünden")
	language.Add("tool.ignite.right", "Brand löschen")

	local ConVarsDefault = TOOL:BuildConVarList()
	function TOOL.BuildCPanel(CPanel)
		CPanel:AddControl("Header", {Text = "#Tool.ignite.name", Description = "#Tool.ignite.desc"})
		CPanel:AddControl("ComboBox", {MenuButton = 1, Folder = "ignite", Options = {["#preset.default"] = ConVarsDefault}, CVars = table.GetKeys(ConVarsDefault)})
		CPanel:AddControl("Slider", {Label = "Brenndauer", Type = "Float", Min = "1", Max = "1000", Command = "ignite_length"})
		CPanel:AddControl("Slider", {Label = "Reichweite", Type = "Int", Min = "0", Max = "250", Command = "ignite_reach"})
	end
end

function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if !IsValid(ent) or ent:IsPlayer() or ent:IsWorld() then return false end
	if CLIENT then return true end
	local leng = math.max(self:GetClientNumber("length"), 1)
	local reach = math.Clamp(self:GetClientNumber("reach"), 0, 250)
	ent:Extinguish()
	ent:Ignite(leng, reach)
	return true
end

function TOOL:RightClick(trace)
	local ent = trace.Entity
	if !IsValid(ent) or ent:IsPlayer() or ent:IsWorld() then return false end
	if CLIENT then return true end
	ent:Extinguish()
	return true
end