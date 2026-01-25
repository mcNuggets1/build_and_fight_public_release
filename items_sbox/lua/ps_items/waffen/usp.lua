ITEM.Name = 'HK USP'
ITEM.Price = 11000
ITEM.Model = 'models/weapons/w_pist_fokkususp.mdl'
ITEM.WeaponClass = 'm9k_usp'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end