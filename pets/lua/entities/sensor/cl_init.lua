include("shared.lua")

if Pets.EnableDynamicLights then 
	function ENT:Think()
		self.BaseClass.Think(self)
		if !IsValid(self.dlight) then
			self.dlight = DynamicLight(self:EntIndex())
		end
		local dlight = self.dlight
		dlight.Pos = self:GetPos() + Vector(0, 0, 10)
		dlight.r = 0
		dlight.g = 102
		dlight.b = 255
		dlight.Brightness = 0.3
		dlight.MinLight = 0.1
		dlight.Size = 54
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 0.5
		dlight.Style = 1
	end 
end