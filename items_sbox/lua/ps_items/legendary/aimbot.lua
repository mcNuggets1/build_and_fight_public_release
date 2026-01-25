ITEM.Name = 'Aimbot Gun'
ITEM.Price = 300000
ITEM.Model = 'models/weapons/w_cloutak1.mdl'
ITEM.WeaponClass = 'weapon_aimbot'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "aimbot", 200)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "aimbot", 200)
end