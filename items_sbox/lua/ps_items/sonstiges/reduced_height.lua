ITEM.Name = 'Spielergröße: -5%'
ITEM.Price = 500000
ITEM.Model = 'models/props_junk/garbage_glassbottle003a.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Größe"

local mod = 0.95
function ITEM:OnEquip(ply, modifications)
	if ply:Alive() and !ply.Dwarf then
		ply.Dwarf = true
		ply:SetModelScale(ply:GetModelScale() * mod, 0)
		ply:SetViewOffset(ply:GetViewOffset() * mod)
		ply:SetViewOffsetDucked(ply:GetViewOffset() - Vector(0, 0, 36))
	end
end

function ITEM:OnHolster(ply)
	if !ply.Dwarf then return end
	ply.Dwarf = nil
	ply:SetModelScale(1, 0)
	ply:SetViewOffset(Vector(0, 0, 64))
	ply:SetViewOffsetDucked(ply:GetViewOffset() - Vector(0, 0, 36))
end