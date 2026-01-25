ITEM.Name = 'Granate [Half-Life 2]'
ITEM.Price = 40000
ITEM.Model = 'models/items/grenadeAmmo.mdl'
ITEM.WeaponClass = 'weapon_frag'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "grenade", 2)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end