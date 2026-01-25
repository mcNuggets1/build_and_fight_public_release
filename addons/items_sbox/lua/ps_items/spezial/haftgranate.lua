ITEM.Name = 'Haftgranate'
ITEM.Price = 40000
ITEM.Model = 'models/weapons/w_sticky_grenade_thrown.mdl'
ITEM.WeaponClass = 'm9k_sticky_grenade'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "sticky_grenade", 2)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end