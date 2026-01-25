ITEM.Name = 'Zufälliges Player-Model'
ITEM.Price = 400000
ITEM.Model = 'models/player/alyx.mdl'

local Skins = {}

timer.Simple(0, function()
	for _, v in pairs(PS.Items) do
		if v.Category == "Player-Models" and v.Name != "Zufälliges Player-Model" then
			table.insert(Skins, v.Model)
		end
	end
end)

function ITEM:OnEquip(ply)
	PS_GivePlayerModel(ply, Skins[math.random(#Skins)])
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end

local next_frame = 0
local current_model
local current_num = 0
function ITEM:ModifyClientsideModel(ply, model, pos, ang, panel)
	if next_frame <= SysTime() then
		next_frame = SysTime() + 1
		current_num = current_num + 1
		if current_num > #Skins then
			current_num = 1
		end
		current_model = Skins[current_num]
	end
	self.Model = current_model
	local ang = model:GetAngles()
	panel:SetModel(current_model)
	if IsValid(panel:GetEntity()) then
		panel:GetEntity():SetAngles(ang)
	end
	return model, pos, ang
end