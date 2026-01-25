include("shared.lua")

ENT.SmokeFadeTime = 2
ENT.SmokeFadeInTime = 1
ENT.SmokeIntensity = 0
ENT.SmokeStartDistance = 384 * 384
ENT.SmokeMaxIntensityDistance = 128

function ENT:Initialize()
	self.InitTime = self:GetCreationTime()
	self.SmokeMaxIntensityDuration = self.SmokeDuration - self.SmokeFadeTime
	self.SmokeEndTime = self.InitTime + self.SmokeDuration
	self.SmokeFadeInDuration = self.InitTime + self.SmokeFadeInTime
	self.PartialIntensityDistance = self.SmokeStartDistance - self.SmokeMaxIntensityDistance
end

function ENT:Draw()
end

function ENT:OnRemove()
	self:StopParticles()
end

local hook_added = false

local function RenderScreenSpaceEffects()
	local ply = LocalPlayer()
	if ply.SmokeScreenIntensity then
		surface.SetDrawColor(100, 100, 100, 255 * ply.SmokeScreenIntensity)
		surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
	end
	ply.SmokeScreenIntensity = nil
	hook_added = false
	hook.Remove("RenderScreenspaceEffects", "M9K_RenderSmokeEffect")
end

function ENT:Think()
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	local cur_time = CurTime()
	local ply_dist = ply:EyePos():DistToSqr(self:GetPos())
	if ply_dist > self.SmokeStartDistance then
		return
	end
	local overall_intens = 0
	if cur_time > self.InitTime + self.SmokeMaxIntensityDuration then
		local time_rel = self.SmokeEndTime - cur_time
		overall_intens = math.Clamp(time_rel / self.SmokeFadeTime, 0, 1)
	else
		if cur_time < self.SmokeFadeInDuration then
			local time_rel = math.Clamp(1 - (self.SmokeFadeInDuration - cur_time) / self.SmokeFadeInTime, 0, 1)
			overall_intens = time_rel
		else
			overall_intens = 1
		end
	end
	if overall_intens == 0 then
		return
	end
	if ply_dist > self.SmokeMaxIntensityDistance then
		local dist_rel = 1 - math.Clamp((ply_dist - self.SmokeMaxIntensityDistance) / self.PartialIntensityDistance, 0, 1)
		overall_intens = overall_intens * dist_rel
	end
	ply.SmokeScreenIntensity = overall_intens
	if ply.SmokeScreenIntensity > 0 and !hook_added then
		hook_added = true
		hook.Add("RenderScreenspaceEffects", "M9K_RenderSmokeEffect", RenderScreenSpaceEffects)
	end
end