ITEM.Name = '9mm Pistole [Half-Life 2]'
ITEM.Price = 2500
ITEM.Model = 'models/weapons/w_pistol.mdl'
ITEM.WeaponClass = 'weapon_pistol'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end