ITEM.Name = 'Cheeseburger'
ITEM.Price = 9000
ITEM.Model = 'models/food/burger.mdl'
ITEM.Attachment = 'eyes'
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Kopfbedeckungen"

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local Size = Vector(2, 2, 2)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(0, 0, 0)
	local MPos = Vector(-2, 0, -22.5)

	local MCustomPos = PS_CheckPMMods(ply, self.EquipGroup)
	if MCustomPos then
		MPos = Vector(MCustomPos[1], MCustomPos[2], MCustomPos[3] - 25)
	end

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end