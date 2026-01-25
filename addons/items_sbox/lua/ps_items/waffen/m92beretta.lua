ITEM.Name = 'M92 Beretta'
ITEM.Price = 8300
ITEM.Model = 'models/weapons/w_beretta_m92.mdl'
ITEM.WeaponClass = 'm9k_m92beretta'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end