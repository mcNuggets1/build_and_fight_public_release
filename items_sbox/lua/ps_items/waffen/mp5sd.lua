ITEM.Name = 'MP5SD'
ITEM.Price = 23000
ITEM.Model = 'models/weapons/w_hk_mp5sd.mdl'
ITEM.WeaponClass = 'm9k_mp5sd'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end