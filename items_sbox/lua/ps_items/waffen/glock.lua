ITEM.Name = 'Glock 18'
ITEM.Price = 18000
ITEM.Model = 'models/weapons/w_dmg_glock.mdl'
ITEM.WeaponClass = 'm9k_glock'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end