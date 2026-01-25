ITEM.Name = 'S.L.A.M'
ITEM.Price = 100000
ITEM.Model = 'models/weapons/w_slam.mdl'
ITEM.WeaponClass = 'weapon_slam'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "slam", 1)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "slam", 1)
end