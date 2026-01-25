ITEM.Name = 'TMP'
ITEM.Price = 21000
ITEM.Model = 'models/weapons/3_smg_tmp.mdl'
ITEM.WeaponClass = 'm9k_tmp'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end