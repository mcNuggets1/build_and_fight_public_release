ITEM.Name = 'Brechstange [Half-Life 2]'
ITEM.Price = 3000
ITEM.Model = 'models/weapons/w_crowbar.mdl'
ITEM.WeaponClass = 'weapon_crowbar'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end