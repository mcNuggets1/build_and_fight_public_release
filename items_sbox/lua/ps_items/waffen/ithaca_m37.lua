ITEM.Name = 'Ithaca M37'
ITEM.Price = 25000
ITEM.Model = 'models/weapons/w_ithaca_m37.mdl'
ITEM.WeaponClass = 'm9k_ithacam37'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end