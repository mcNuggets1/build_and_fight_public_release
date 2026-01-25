include("shared.lua")

SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.DrawAmmo = false

SWEP.VElements = {
	["Yellowbox+"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Yellowbox", pos = Vector(-3.182, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.05, 0.1, 0.029), color = Color(255, 255, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["Yellowbox"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0.259, 0, 2.273), angle = Angle(90, 0, 180), size = Vector(0.05, 0.1, 0.029), color = Color(255, 255, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["Yellowbox+++"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.171, 1.784, -0.456), angle = Angle(0, 90, -101.25), size = Vector(0.054, 0.293, 0.05), color = Color(0, 0, 24, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["Yellowbox++"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Yellowbox", pos = Vector(-1.8, -0.201, -0.75), angle = Angle(90, -90, 0), size = Vector(0.054, 0.4, 0.05), color = Color(0, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/stripes", skin = 0, bodygroup = {}},
	["Blackreceiver"] = {type = "Model", model = "models/props_c17/furniturewashingmachine001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Yellowbox", pos = Vector(-3.5, 0, -0.201), angle = Angle(0, -90, 90), size = Vector(0.119, 0.054, 0.3), color = Color(0, 0, 0, 0), surpresslightning = false, material = "phoenix_storms/stripes", skin = 0, bodygroup = {}},
	["counter"] = {type = "Quad", bone = "ValveBiped.Bip01_R_Hand", rel = "Blackreceiver", pos = Vector(0, 0, 4.099), angle = Angle(0, -90, 0), size = 0.02, draw_func = nil}
}

SWEP.WElements = {
	["Yellowbox+"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", weaponbone = true, bone = "ValveBiped.Bip01_R_Hand", rel = "Yellowbox", pos = Vector(-3.182, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.05, 0.12, 0.05), color = Color(255, 255, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["Yellowbox"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", weaponbone = true, bone = "ValveBiped.Weapon_bone", rel = "", pos = Vector(1, 0, 1.2), angle = Angle(175, 0, -81.5), size = Vector(0.05, 0.12, 0.05), color = Color(255, 255, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["Yellowbox+++"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", weaponbone = true, bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.9, 1.984, -0.456), angle = Angle(-8, 90, -90), size = Vector(0.054, 0.2, 0.055), color = Color(0, 0, 24, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {}},
	["Yellowbox++"] = {type = "Model", model = "models/props_c17/furniturefridge001a.mdl", weaponbone = true, bone = "ValveBiped.Bip01_R_Hand", rel = "Yellowbox", pos = Vector(0.2, -0.201, -1.3), angle = Angle(90, -90, 0), size = Vector(0.09, 0.4, 0.06), color = Color(0, 0, 0, 255), surpresslightning = false, material = "phoenix_storms/stripes", skin = 0, bodygroup = {}},
}

local col1 = Color(0, 255, 0, 255)
local col2 = Color(255, 0, 0, 255)
function SWEP:DoDrawCrosshair()
	local w, h = ScrW(), ScrH()
	local w2, h2 = w / 2, h / 2
	local ply = LocalPlayer()
	if !self.tr_taseplayer or self.next_tr < CurTime() then
		self.tr_taseplayer = util.TraceLine(util.GetPlayerTrace(ply))
		self.next_tr = CurTime() + 0.01
	end
	local hit = self.tr_taseplayer.HitPos:DistToSqr(ply:GetShootPos()) <= self.Range and (IsValid(self.tr_taseplayer.Entity) and self.tr_taseplayer.Entity:IsPlayer() and !self.tr_taseplayer.Entity:GetNoDraw())
	surface.SetDrawColor(hit and col1 or col2)
	local gap = (hit and 0 or 5) + 1
	surface.DrawRect(w2 - 1, h2, 1, 1)
	surface.DrawRect(w2 + 9, h2, 1, 1)
	surface.DrawRect(w2 - 11, h2, 1, 1)
	surface.DrawRect(w2 - 1, h2 + 8, 1, 1)
	surface.DrawRect(w2 - 1, h2 - 8, 1, 1)
	return true
end

local view = {}
local function CalcView(ply, origin, angles, fov)
	local taserentity = ply.TaseredEntity
	if IsValid(taserentity) then
		local bid = taserentity:LookupBone("ValveBiped.Bip01_Head1")
		if bid then
			local pos,ang = taserentity:GetBonePosition(bid)
			pos = pos + ang:Forward() * 7
			ang:RotateAroundAxis(ang:Up(), -90)
			ang:RotateAroundAxis(ang:Forward(), -90)
			pos = pos + ang:Forward() * 1
			view.origin = pos
			view.angles = ang
			return view
		end
	end
end
hook.Add("CalcView", "Taser_CalcView", CalcView)

local TasedPlayers = {}
hook.Add("NetworkEntityCreated", "Taser_RagdollCreated", function(ent)
	if ent:IsRagdoll() then
		local ply = ent:GetDTEntity(0)
		if IsValid(ply) and ply:IsPlayer() then
			TasedPlayers[ent:EntIndex()] = ent
			ply.TaseredEntity = ent
			if ent:GetCreationTime() > CurTime() - 1 then
				ent:SnatchModelInstance(ply)
			end
			ent.GetPlayerColor = function()
				return ply:GetPlayerColor()
			end
		end
	end
end)

hook.Add("EntityRemoved", "Taser_RagdollRemoved", function(ent)
	if ent:IsRagdoll() then
		TasedPlayers[ent:EntIndex()] = nil
	end
end)

local function GrabPlyInfo(ply)
	return ply:Name(), (team.GetColor(ply:Team()) or color_white), "ChatFont"
end

local local_ply
local function DrawInfo()
	local_ply = local_ply or LocalPlayer()
	local targ = local_ply:GetEyeTrace().Entity
	if IsValid(targ) and IsValid(targ:GetDTEntity(0)) and targ:GetDTEntity(0):IsPlayer() then
		local pos = targ:GetPos():ToScreen()
		local ply2 = targ:GetDTEntity(0)
		local nick, nickclr, font = GrabPlyInfo(ply2)
		draw.DrawText(nick, font, pos.x, pos.y - 30, nickclr, 1)
		draw.DrawText(math.max(0, ply2:Health()).."%", "ChatFont", pos.x, pos.y - 10, nickclr, 1)
	end
end
hook.Add("HUDPaint", "Taser_DrawInfo", DrawInfo)

local boltpositions
local boltcount
local poly
local glowtimer = 0
local bolt1 = Material("taser/lightningbolt.png")
local bolt1_o = Material("taser/lightningbolt_outline.png")
local bolt1_g = Material("taser/lightningbolt_glow.png")
local bolt2 = Material("taser/lightningbolt2.png")
function SWEP:DrawScreen(x, y, w, h)
	local frac = (self:GetCharge() or 0) / 100
	local fracinv = 1 - frac
	if frac >= 1 then
		glowtimer = glowtimer + 1
	else
		glowtimer = 0
	end
	local bx, by = x + w / 2 - 16, y + h / 2 - 32 + 10
	if !poly then
		boltpositions = {}
		local v
		local a
		for i=-30, 30, 14 do
			v = Vector(0, by - 25, 0)
			a = Angle(0, i, 0)
			v:Rotate(a)
			table.insert(boltpositions, {pos = v, ang = a})
		end
		boltcount = #boltpositions
		poly = {{x = bx, y = by + (fracinv * 64), u = 0, v = fracinv}, {x = bx + 32, y = by + (fracinv * 64), u = 1, v = fracinv}, {x = bx + 32, y = by + 64, u = 1, v = 1}, {x = bx, y = by + 64, u = 0, v = 1}}
	end
	surface.SetDrawColor(color_white)
	surface.SetMaterial(bolt1)
	poly[1].y = by + (fracinv * 64)
	poly[1].v = fracinv
	poly[2].y = poly[1].y
	poly[2].v = poly[1].v
	surface.DrawPoly(poly)
	surface.SetMaterial(bolt1_o)
	surface.DrawTexturedRect(bx, by, 32, 64)
	surface.SetMaterial(bolt2)
	local a
	for k,v in pairs(boltpositions) do
		a = math.Clamp((frac * (254 * boltcount)) - (254 * (k - 1)), 0, 254)
		surface.SetDrawColor(Color(0,0,255,a + 1))
		surface.DrawTexturedRectRotated(v.pos.x + (x + w / 2), v.pos.y, 16, 32, - (v.ang.y))
	end
	surface.SetDrawColor(Color(255, 255, 255, math.cos(glowtimer / 40 + math.pi) * 50 + 50))
	surface.SetMaterial(bolt1_g)
	surface.DrawTexturedRect(bx - 16, by - 32, 64, 128)
end