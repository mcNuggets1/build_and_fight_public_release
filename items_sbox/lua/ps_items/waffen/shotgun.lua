ITEM.Name = 'Schrotflinte [Half-Life 2]'
ITEM.Price = 5000
ITEM.Model = 'models/weapons/w_shotgun.mdl'
ITEM.WeaponClass = 'weapon_shotgun'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end