ITEM.Name = 'KAC PDW'
ITEM.Price = 21000
ITEM.Model = 'models/weapons/w_kac_pdw.mdl'
ITEM.WeaponClass = 'm9k_kac_pdw'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end