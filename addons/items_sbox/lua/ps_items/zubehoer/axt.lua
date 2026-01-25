ITEM.Name = 'Axt'
ITEM.Price = 12000
ITEM.Model = 'models/props/cs_militia/axe.mdl'
ITEM.Bone = 'ValveBiped.Bip01_L_Hand'
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Hände"

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local MAngle = Angle(256, 0, 0)
	local MPos = Vector(4, 1, 0)

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end