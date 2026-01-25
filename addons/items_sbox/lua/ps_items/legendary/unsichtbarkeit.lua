ITEM.Name = 'Uhr der Unsichtbarkeit'
ITEM.Price = 160000
ITEM.Model = 'models/props_combine/breenclock.mdl'
ITEM.WeaponClass = 'weapon_cloak'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end