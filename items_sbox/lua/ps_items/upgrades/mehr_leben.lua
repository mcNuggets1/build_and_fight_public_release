ITEM.Name = '1% mehr Leben'
ITEM.Price = 90000
ITEM.Model = 'models/items/healthkit.mdl'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	ply:SetMaxHealth(ply:GetMaxHealth() + 1)
	ply:SetHealth(ply:Health() + 1)
end

function ITEM:OnHolster(ply)
	if ply:Health() <= 0 then return end
	ply:SetMaxHealth(ply:GetMaxHealth() - 1)
	ply:SetHealth(ply:Health() - 1)
	if ply:Alive() and ply:Health() <= 0 then
		ply:Kill()
	end
end