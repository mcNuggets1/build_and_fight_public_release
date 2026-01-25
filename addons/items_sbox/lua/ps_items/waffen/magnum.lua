ITEM.Name = '.357 Magnum [Half-Life 2]'
ITEM.Price = 15000
ITEM.Model = 'models/weapons/w_357.mdl'
ITEM.WeaponClass = 'weapon_357'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end