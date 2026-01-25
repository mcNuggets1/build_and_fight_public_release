ITEM.Name = 'P228'
ITEM.Price = 10000
ITEM.Model = 'models/weapons/3_pist_p228.mdl'
ITEM.WeaponClass = 'm9k_p228'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end