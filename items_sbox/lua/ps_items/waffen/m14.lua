ITEM.Name = 'M14'
ITEM.Price = 29000
ITEM.Model = 'models/weapons/w_snip_m14sp.mdl'
ITEM.WeaponClass = 'm9k_m14sp'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end