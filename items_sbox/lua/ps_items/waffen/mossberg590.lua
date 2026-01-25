ITEM.Name = 'Mossberg 590'
ITEM.Price = 38000
ITEM.Model = 'models/weapons/w_mossberg_590.mdl'
ITEM.WeaponClass = 'm9k_mossberg590'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end