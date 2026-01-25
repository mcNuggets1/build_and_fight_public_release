ITEM.Name = 'Remington 1858'
ITEM.Price = 9100
ITEM.Model = 'models/weapons/w_remington_1858.mdl'
ITEM.WeaponClass = 'm9k_remington1858'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end