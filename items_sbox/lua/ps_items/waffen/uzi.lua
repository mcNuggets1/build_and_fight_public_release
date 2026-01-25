ITEM.Name = 'UZI'
ITEM.Price = 13000
ITEM.Model = 'models/weapons/w_uzi_imi.mdl'
ITEM.WeaponClass = 'm9k_uzi'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end