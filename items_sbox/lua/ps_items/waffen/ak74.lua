ITEM.Name = 'AK-74'
ITEM.Price = 18000
ITEM.Model = 'models/weapons/w_ak47_m9k.mdl'
ITEM.WeaponClass = 'm9k_ak74'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end