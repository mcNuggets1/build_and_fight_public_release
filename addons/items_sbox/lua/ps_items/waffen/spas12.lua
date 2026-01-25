ITEM.Name = 'SPAS12'
ITEM.Price = 80000
ITEM.Model = 'models/weapons/w_spas_12.mdl'
ITEM.WeaponClass = 'm9k_spas12'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end