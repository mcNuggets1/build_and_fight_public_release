ITEM.Name = 'AAC Honeybadger'
ITEM.Price = 30000
ITEM.Model = 'models/weapons/w_aac_honeybadger.mdl'
ITEM.WeaponClass = 'm9k_honeybadger'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end