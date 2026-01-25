ITEM.Name = 'Kamera'
ITEM.Price = 1000
ITEM.Model = 'models/maxofs2d/camera.mdl'
ITEM.WeaponClass = 'gmod_camera'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end