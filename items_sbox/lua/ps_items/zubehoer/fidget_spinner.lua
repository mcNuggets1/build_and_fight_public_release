ITEM.Name = 'Uralter Fidget Spinner'
ITEM.Price = 15000
ITEM.Model = 'models/props_citizen_tech/windmill_blade004a.mdl'
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
	local Size = Vector(0.05, 0.05, 0.05)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(180, 75, 180)
	local MPos = Vector(2.5, 1.7999999523163, 0.5)

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	model.ModelDrawingAngle = model.ModelDrawingAngle or Angle(0,0,0)
	model.ModelDrawingAngle.p = (CurTime() * 2 * 90)
	model.ModelDrawingAngle.y = (CurTime() * 0 * 90)
	model.ModelDrawingAngle.r = (CurTime() * 0 * 90)

	ang:RotateAroundAxis(ang:Forward(), (model.ModelDrawingAngle.p))
	ang:RotateAroundAxis(ang:Up(), (model.ModelDrawingAngle.y))
	ang:RotateAroundAxis(ang:Right(), (model.ModelDrawingAngle.r))

	return model, pos, ang
end