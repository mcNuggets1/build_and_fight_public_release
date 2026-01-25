ITEM.Name = 'Blutfarbe: Grün'
ITEM.Price = 60000
ITEM.Model = 'models/vortigaunt.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Blutfarbe"

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:SetBloodColor(BLOOD_COLOR_GREEN)
	end
end

function ITEM:OnHolster(ply)
	ply:SetBloodColor(BLOOD_COLOR_RED)
end