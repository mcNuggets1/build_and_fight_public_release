ITEM.Name = 'Tommy Gun'
ITEM.Price = 32000
ITEM.Model = 'models/weapons/w_tommy_gun.mdl'
ITEM.WeaponClass = 'm9k_thompson'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end