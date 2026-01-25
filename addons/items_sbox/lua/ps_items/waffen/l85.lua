ITEM.Name = 'L85'
ITEM.Price = 35000
ITEM.Model = 'models/weapons/w_l85a2.mdl'
ITEM.WeaponClass = 'm9k_l85'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end