ITEM.Name = 'Harpune'
ITEM.Price = 15000
ITEM.Model = 'models/props_junk/harpoon002a.mdl'
ITEM.WeaponClass = 'm9k_harpoon'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end