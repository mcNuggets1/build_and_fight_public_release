ITEM.Name = 'Melonlauncher'
ITEM.Price = 90000
ITEM.Model = 'models/weapons/w_rocket_launcher.mdl'
ITEM.WeaponClass = 'weapon_melonlauncher'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end