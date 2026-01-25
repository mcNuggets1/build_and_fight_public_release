ITEM.Name = 'Teleportationsfähigkeit'
ITEM.Price = 120000
ITEM.Model = 'models/weapons/w_slam.mdl'
ITEM.WeaponClass = 'weapon_blink'
ITEM.SingleUse = false
ITEM.ModelImageColor = Color(255, 0, 0)

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end