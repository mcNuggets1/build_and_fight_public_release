EFFECT.Mat = Material("effects/spark")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	local ent = data:GetEntity()
	local att = data:GetAttachment()
	if (IsValid(ent) and att > 0) then
		if (ent.Owner == LocalPlayer() and !LocalPlayer():GetViewModel() != LocalPlayer()) then
			ent = ent.Owner:GetViewModel()
		end
		local att = ent:GetAttachment(att)
		if att then
			self.StartPos = att.Pos
		end
	end
	self.Dir = self.EndPos - self.StartPos
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	self.TracerTime = math.Clamp(self.StartPos:DistToSqr(self.EndPos) / 100000000, 0.05, 0.55)
	self.Length = 0.25
	self.DieTime = CurTime() + self.TracerTime
end

function EFFECT:Think()
	if (CurTime() > self.DieTime) then
		return false
	end
	return true
end

function EFFECT:Render()
	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp(fDelta, 0, 1) ^ 0.5
	render.SetMaterial(self.Mat)
	local sinWave = math.sin(fDelta * math.pi)
	render.DrawBeam(self.EndPos - self.Dir * (fDelta - sinWave * self.Length), self.EndPos - self.Dir * (fDelta + sinWave * self.Length), 2 + sinWave * 16, 1, 0, Color(0, 255, 0, 255))
end