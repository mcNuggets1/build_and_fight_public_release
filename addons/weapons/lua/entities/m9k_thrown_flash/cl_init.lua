include("shared.lua")

function ENT:OnRemove()
	local dlight = DynamicLight(self:EntIndex())
	dlight.r = 255 
	dlight.g = 255
	dlight.b = 255
	dlight.Brightness = 4
	dlight.Pos = self:GetPos()
	dlight.Size = 256
	dlight.Decay = 128
	dlight.DieTime = CurTime() + 0.1
end

local hook_exists = false

local function RenderScreenSpaceEffects()
	local ply = LocalPlayer()
	local cur_time = CurTime()
	local f_time = FrameTime()
	if cur_time > ply.FlashbangDuration then
		ply.FlashbangIntensity = math.Approach(ply.FlashbangIntensity, 0, f_time)
	end
	ply.FlashbangDisplayIntensity = ply.FlashbangDisplayIntensity or 0
	ply.FlashbangDisplayIntensity = math.Approach(ply.FlashbangDisplayIntensity, ply.FlashbangIntensity, f_time * 15)
	if cur_time > ply.FlashbangDuration then
		ply.FlashbangIntensity = math.Approach(ply.FlashbangIntensity, 0, f_time)
	end
	if ply.FlashbangDisplayIntensity > 0 then
		DrawMotionBlur(0.01 * (1 - ply.FlashbangDisplayIntensity), ply.FlashbangDisplayIntensity, 0)
		surface.SetDrawColor(255, 255, 255, 255 * ply.FlashbangIntensity * ply.FlashbangDisplayIntensity)
		surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
	else
		hook_exists = false
		hook.Remove("RenderScreenspaceEffects", "M9K_RenderFlashbang")
	end
end

local function FlashbangEffect(data)
	local intensity = data:ReadFloat()
	local duration = data:ReadFloat()
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	ply.FlashbangIntensity = intensity
	ply.FlashbangDuration = CurTime() + duration
	ply.FlashbangDuration = CurTime() + duration * 0.75
	ply.FlashbangIntensity = math.max(intensity * 1.5, 1)
	if intensity > 0.6 then
		ply:SetDSP(35, duration <= 1)
	end
	if !hook_exists then
		hook_exists = true
		hook.Add("RenderScreenspaceEffects", "M9K_RenderFlashbang", RenderScreenSpaceEffects)
	end
end
usermessage.Hook("M9K_FLASHED", FlashbangEffect)