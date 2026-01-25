TOOL.Category = "Build & Fight"
TOOL.Name = "#tool.hp.name"

TOOL.ClientConVar["amount"] = 100

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}

function TOOL:LeftClick(trace)
	local ent = trace.Entity
    if !IsValid(ent) or ent:IsPlayer() or ent:IsVehicle() or ent:GetClass() == "spawnpoint" then return false end
	if CLIENT then return true end
	local hp = self:GetClientNumber("amount")
	if !isnumber(hp) or hp < 0 then return end
	ent.PreviousHealth = ent:Health()
	ent:SetHealth(self:GetClientNumber("amount"))
	self:GetOwner():ChatPrint("Lebenspunkte auf "..string.Comma(math.ceil(ent:Health())).." gesetzt.")
	return true
end

function TOOL:RightClick(trace)
	local ent = trace.Entity
    if !IsValid(ent) or ent:IsPlayer() or ent:IsVehicle() or ent:GetClass() == "spawnpoint" then return false end
	if CLIENT then return true end
	RunConsoleCommand("hp_amount", ent:Health())
	self:GetOwner():ChatPrint("Lebensanzahl von "..string.Comma(math.ceil(ent:Health())).." Punkten kopiert.")
	return true
end

function TOOL:Reload(trace)
	local ent = trace.Entity
    if !IsValid(ent) or ent:IsPlayer() or ent:IsVehicle() or ent:GetClass() == "spawnpoint" then return false end
	if CLIENT then return true end
	ent:SetHealth(ent.PreviousHealth or ent:Health())
	ent.PreviousHealth = ent:Health()
	self:GetOwner():ChatPrint("Lebenspunkte auf "..string.Comma(math.ceil(ent:Health())).." zurückgesetzt.")
	return true
end

if CLIENT then
	language.Add("tool.hp.name", "Lebensanzahl")
	language.Add("tool.hp.desc", "Modifiziert die Lebenspunkte von Gegenständen.")
	language.Add("tool.hp.left", "Lebenspunkte setzen")
	language.Add("tool.hp.right", "Derzeitige Lebenspunkte kopieren")
	language.Add("tool.hp.reload", "Lebenspunkte zurücksetzen")
	function TOOL:BuildCPanel(panel)
		self:AddControl("Header", {Text = "#tool.hp.name", Description = "#tool.hp.desc"})
		self:AddControl("Slider", {Label = "Lebenspunkte", Type = "Int", Min = "0", Max = "1000000", Command = "hp_amount"})
	end
end
