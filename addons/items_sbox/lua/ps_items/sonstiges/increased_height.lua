ITEM.Name = 'Spielergröße: +10%'
ITEM.Price = 100000
ITEM.Model = 'models/props_junk/glassbottle01a.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Größe"

local mod = 1.1
function ITEM:OnEquip(ply, modifications)
	if ply:Alive() and !ply.Huge then
		ply.Huge = true
		ply:SetModelScale(ply:GetModelScale() * mod, 0)
		ply:SetViewOffset(ply:GetViewOffset() * mod)
		ply:SetViewOffsetDucked(ply:GetViewOffset() - Vector(0, 0, 36))
	end
end

function ITEM:OnHolster(ply)
	if !ply.Huge then return end
	ply.Huge = nil
	ply:SetModelScale(1, 0)
	ply:SetViewOffset(Vector(0, 0, 64))
	ply:SetViewOffsetDucked(ply:GetViewOffset() - Vector(0, 0, 36))
end