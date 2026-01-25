ITEM.Name = 'M3 Super 90'
ITEM.Price = 37000
ITEM.Model = 'models/weapons/3_shot_m3super90.mdl'
ITEM.WeaponClass = 'm9k_m3super'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end