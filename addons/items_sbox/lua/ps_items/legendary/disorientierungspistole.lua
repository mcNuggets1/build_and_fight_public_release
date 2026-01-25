ITEM.Name = 'Desorientierungspistole'
ITEM.Price = 110000
ITEM.Model = 'models/weapons/w_alyx_gun.mdl'
ITEM.WeaponClass = 'weapon_disorientation'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end