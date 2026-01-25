ITEM.Name = 'FG 42'
ITEM.Price = 45000
ITEM.Model = 'models/weapons/w_fg42.mdl'
ITEM.WeaponClass = 'm9k_fg42'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end