ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Aspirin"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.EFFECT_TEXT = "Temporärer Lebensanstieg (+75 Leben)"
ENT.IsLegal = true

if CLIENT then
	killicon.Add("drug_aspirin", "killicons/drug_aspirin_killicon", Color(255, 80, 0, 255))
end