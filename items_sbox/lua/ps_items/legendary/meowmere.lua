ITEM.Name = 'Meowmere'
ITEM.Price = 150000
ITEM.Model = 'models/meowmere/meowmere.mdl'
ITEM.WeaponClass = 'weapon_meowmere'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end