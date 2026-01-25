ITEM.Name = 'HK MP5'
ITEM.Price = 21000
ITEM.Model = 'models/weapons/w_hk_mp5.mdl'
ITEM.WeaponClass = 'm9k_mp5'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end