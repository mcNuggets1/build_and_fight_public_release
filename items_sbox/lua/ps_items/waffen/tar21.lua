ITEM.Name = 'TAR-21'
ITEM.Price = 28000
ITEM.Model = 'models/weapons/w_imi_tar21.mdl'
ITEM.WeaponClass = 'm9k_tar21'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end