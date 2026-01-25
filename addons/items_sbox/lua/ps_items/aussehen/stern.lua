ITEM.Name = 'Stern'
ITEM.Price = 13000
ITEM.Model = 'models/marioragdoll/super mario galaxy/star/star.mdl'
ITEM.Attachment = 'eyes'
ITEM.Weight = 2

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local Size = Vector(1.5, 1, 1)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(0, 0, 0)
	local MPos = Vector(-2.5, 0, -8.5)

	local MCustomPos = PS_CheckPMMods(ply, self.EquipGroup)
	if MCustomPos then
		MPos = Vector(MCustomPos[1], MCustomPos[2], MCustomPos[3])
	end

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end