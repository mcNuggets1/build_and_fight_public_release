ITEM.Name = 'Popcorn'
ITEM.Price = 70000
ITEM.Model = 'models/teh_maestro/popcorn.mdl'
ITEM.WeaponClass = 'weapon_popcorn'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end