ITEM.Name = 'Lichtschwert'
ITEM.Price = 250000
ITEM.Model = 'models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl'
ITEM.WeaponClass = 'weapon_lightsaber'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end