ITEM.Name = 'HK USC'
ITEM.Price = 22000
ITEM.Model = 'models/weapons/w_hk_usc.mdl'
ITEM.WeaponClass = 'm9k_usc'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end