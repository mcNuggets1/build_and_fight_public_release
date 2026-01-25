ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Drogen"
ENT.Category = "Drogen"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.LASTINGEFFECT = 0
ENT.TRANSITION_TIME = 0
ENT.EFFECT_TEXT = "Kein Effekt"
ENT.IsDrug = true
ENT.IsLegal = false
ENT.IsDeadly = true

local drug_vars = {}
if CLIENT then
	net.Receive("drug_updatevar", function()
		local name = net.ReadString()
		local var = net.ReadFloat()
		drug_vars[name] = var
		hook.Run("drug_varcall", name, var)
	end)
end

local Player = FindMetaTable("Player")
function Player:GetDrugVar(name)
	return SERVER and self[name] or CLIENT and drug_vars[name] or 0
end

if DarkRP then
	function ENT:PhysgunPickup(ply)
		return ply:IsAdmin()
	end

	function ENT:CanTool(ply, trace, mode)
		return mode == "remover" and ply:IsAdmin()
	end
end

if CLIENT then
	local use_font = system.IsWindows() and "Tahoma" or "Verdana"
	surface.CreateFont("mg_entfont", {font = use_font, size = 35, weight = 1000, blursize = 0, antialias = true, shadow = false})
	surface.CreateFont("mg_entfont2", {font = use_font, size = 25, weight = 600, blursize = 0, antialias = true, shadow = false})

	function ENT:Draw()
		self:DrawModel()
	end

	local local_ply, dist
	local vector_1 = Vector(0, 0, 1)
	function ENT:DrawTranslucent()
		local_ply = local_ply or LocalPlayer()
		dist = local_ply:EyePos():DistToSqr(self:GetPos())
		if dist > 40000 then return end
		local ang = self:GetAngles()	
		local pos = self:GetPos() + (vector_1 * (self:OBBMaxs().z + 5 + math.sin(SysTime() * 2) * 2))
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 0)
		cam.Start3D2D(pos, Angle(0, EyeAngles().y - 90, 90), 0.1)
			local col = DarkRP and (self.IsLegal and Color(127, 255, 0, 255) or Color(255, 0, 0, 255)) or color_white
			draw.SimpleTextOutlined(self.PrintName, "mg_entfont", 0, -130, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined("Wirkdauer: "..(self.LASTINGEFFECT == 0 and "Sofortig" or self.LASTINGEFFECT.."s"), "mg_entfont2", 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined("Effekt: "..self.EFFECT_TEXT, "mg_entfont2", 0, -70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined("Tödlich: "..(self:GetClass() == "drug_heroine" and "Definitiv" or self.IsDeadly and "Ja" or "Nein"), "mg_entfont2", 0, -40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			if self.EpilepsyWarn then
				draw.SimpleTextOutlined("> Epilepsiewarnung <", "mg_entfont2", 0, -10, Color(200, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			end
		cam.End3D2D()
	end
end