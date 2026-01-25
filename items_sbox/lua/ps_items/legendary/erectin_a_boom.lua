ITEM.Name = 'Erectin A BOOM'
ITEM.Price = 150000
ITEM.Model = 'models/props_lab/citizenradio.mdl'
ITEM.WeaponClass = 'weapon_boom'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end