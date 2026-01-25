ITEM.Name = 'Doppelläufige Schrotflinte'
ITEM.Price = 80000
ITEM.Model = 'models/weapons/w_double_barrel_shotgun.mdl'
ITEM.WeaponClass = 'm9k_dbarrel'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end