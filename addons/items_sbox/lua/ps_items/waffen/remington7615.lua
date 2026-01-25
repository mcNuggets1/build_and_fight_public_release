ITEM.Name = 'Remington 7615P'
ITEM.Price = 24000
ITEM.Model = 'models/weapons/w_remington_7615p.mdl'
ITEM.WeaponClass = 'm9k_remington7615p'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end