ITEM.Name = 'Schlagstock [Half-Life 2]'
ITEM.Price = 8000
ITEM.Model = 'models/weapons/w_stunbaton.mdl'
ITEM.WeaponClass = 'weapon_stunstick'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end