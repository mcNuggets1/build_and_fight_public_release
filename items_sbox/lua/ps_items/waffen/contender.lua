ITEM.Name = 'Thompson Contender G2'
ITEM.Price = 20000
ITEM.Model = 'models/weapons/w_g2_contender.mdl'
ITEM.WeaponClass = 'm9k_contender'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end