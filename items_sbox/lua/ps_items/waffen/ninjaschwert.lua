ITEM.Name = 'Ninjaschwert'
ITEM.Price = 12000
ITEM.Model = 'models/weapons/w_damascus_sword.mdl'
ITEM.WeaponClass = 'm9k_damascus'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end