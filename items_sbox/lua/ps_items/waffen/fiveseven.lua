ITEM.Name = 'Five SeveN'
ITEM.Price = 7300
ITEM.Model = 'models/weapons/3_pist_fiveseven.mdl'
ITEM.WeaponClass = 'm9k_fiveseven'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end