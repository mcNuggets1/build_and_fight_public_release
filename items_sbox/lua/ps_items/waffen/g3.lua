ITEM.Name = 'HK G3A3'
ITEM.Price = 43000
ITEM.Model = 'models/weapons/w_hk_g3.mdl'
ITEM.WeaponClass = 'm9k_g3a3'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end