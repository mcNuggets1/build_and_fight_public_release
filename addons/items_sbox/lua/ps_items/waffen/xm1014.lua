ITEM.Name = 'XM 1014'
ITEM.Price = 40000
ITEM.Model = 'models/weapons/3_shot_xm1014.mdl'
ITEM.WeaponClass = 'm9k_xm1014'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end