ITEM.Name = 'Blutfarbe: Zombie'
ITEM.Price = 80000
ITEM.Model = 'models/zombie/classic.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Blutfarbe"

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:SetBloodColor(BLOOD_COLOR_ZOMBIE)
	end
end

function ITEM:OnHolster(ply)
	ply:SetBloodColor(BLOOD_COLOR_RED)
end