local speed_mult = CreateClientConVar("shop_speed_mult", 0.1, FCVAR_ARCHIVE)

local meta = FindMetaTable("Panel")
function meta:PS_PanelAnim_Fade(data)
	local speed = data.Speed * math.Clamp(speed_mult:GetFloat(), 0.1, 1)
	local starttime = CurTime() + (data.Delay and data.Delay * math.Clamp(speed_mult:GetFloat(), 0.1, 1) or 0)
	local fade = (data.Fade or false)
	local OldThink = self.Think or function() end
	if self.SetDisabled then
		self:SetDisabled(true)
	end
	local SP = 0 - self:GetWide()
	function self:Think()
		OldThink(self)
		local deltatime = math.min(speed, CurTime() - starttime)
		if deltatime > 0 then
			if self.SetDisabled then
				self:SetDisabled(false)
			end
			local DeltaSpeed = (math.pow(deltatime / speed, 1))
			if fade then
				self:SetAlpha(DeltaSpeed * (255 + fade) - fade)
			end
			if deltatime >= speed then
				function self:Think()
					OldThink(self)
				end
				return
			end
		else
			self:SetAlpha(0)
		end
	end
end

function meta:PS_PanelAnim_Appear_FlyIn(data)
	local delayvalue = (data.Delay or 0)
	local delay = CurTime() + delayvalue	
	local dir = data.Dir or "FromLeft"
	local speed = data.Speed * math.Clamp(speed_mult:GetFloat(), 0.1, 1)
	local starttime = CurTime() + delayvalue * math.Clamp(speed_mult:GetFloat(), 0.1, 1)
	local smooth = data.Smooth or 1
	local OldThink = self.Think or function() end
	if dir == "FromLeft" then
		self.PA = {}
		local PX,PY = self:GetPos()
		self.PA.Pos = {x = PX, y = PY}
		self:SetPos(0  -self:GetWide(),PY)
		local SP = 0 - self:GetWide()
		function self:Think()
			OldThink(self)
			local deltatime = math.min(speed, CurTime() - starttime)
			if deltatime > 0 then
				local DeltaSpeed = (math.pow(deltatime / speed, 1 / smooth))
				self:SetPos(SP + (PX + self:GetWide()) * DeltaSpeed, PY)
				if deltatime >= speed then
					function self:Think()
						OldThink(self)
					end
					return
				end
			end
		end
	elseif dir == "FromRight" then
		self.PA = {}
		local PX, PY = self:GetPos()
		self.PA.Pos = {x = PX, y = PY}
		self:SetPos(ScrW(), PY)
		function self:Think()
			OldThink(self)
			local deltatime = math.min(speed, CurTime() - starttime)
			if deltatime > 0 then
				local DeltaSpeed = (math.pow(deltatime / speed, 1 / smooth))
				self:SetPos(ScrW() - (ScrW() - PX) * DeltaSpeed, PY)
				if deltatime >= speed then
					function self:Think()
						OldThink(self)
					end
					return
				end
			end
		end
	elseif dir == "FromTop" then
		self.PA = {}
		local PX, PY = self:GetPos()
		self.PA.Pos = {x = PX, y = PY}
		self:SetPos(PX, 0 - self:GetTall())
		function self:Think()
			OldThink(self)
			local deltatime = math.min(speed, CurTime() - starttime)
			if deltatime > 0 then
				local DeltaSpeed = (math.pow(deltatime / speed, 1 / smooth))
				self:SetPos(PX, PY * DeltaSpeed)
				if deltatime >= speed then
					function self:Think()
						OldThink(self)
					end
					return
				end
			end
		end
	elseif dir == "FromBottom" then
		self.PA = {}
		local PX, PY = self:GetPos()
		self.PA.Pos = {x = PX, y = PY}
		self:SetPos(PX, ScrH() + self:GetTall())
		function self:Think()
			OldThink(self)
			local deltatime = math.min(speed, CurTime() - starttime)
			if deltatime > 0 then
				local DeltaSpeed = (math.pow(deltatime / speed, 1 / smooth))
				self:SetPos(PX, ScrH() - (ScrH() - PY) * DeltaSpeed)
				if deltatime >= speed then
					function self:Think()
						OldThink(self)
					end
					return
				end
			end
		end
	end
end