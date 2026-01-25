ITEM.Name = 'Goldkanone'
ITEM.Price = 120000
ITEM.Model = 'models/weapons/w_physics.mdl'
ITEM.WeaponClass = 'weapon_goldcannon'
ITEM.SingleUse = false
ITEM.ModelImageColor = Color(255, 255, 0)

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetMaterial("models/debug/debugwhite")
	return model, pos, ang
end