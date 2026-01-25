ITEM.Name = 'Mittelalterliche Kanone'
ITEM.Price = 160000
ITEM.Model = 'models/props_phx/cannon.mdl'
ITEM.WeaponClass = 'weapon_cannon'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "cannonballs", 2)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "cannonballs", 2)
end