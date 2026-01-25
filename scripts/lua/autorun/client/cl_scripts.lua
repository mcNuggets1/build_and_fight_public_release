hook.Add("ChatText", "Util_HideJoinLeaveMessages", function(index, name, text, typ)
	if (typ == "joinleave" or typ == "namechange") then return true end
end)

local viewPos
local lastUpdate = 0
function MG_GetCamPos()
	local sysTime = SysTime()

	if lastUpdate <= sysTime then
		lastUpdate = sysTime + 0.1

		viewPos = render.GetViewSetup().origin
	end

	return viewPos
end

timer.Simple(0, function()
	local IsValid = IsValid
	local isvector = isvector

	local fallbackClr = Vector(62 / 255, 88 / 255, 106 / 255)
	matproxy.Add({
		name = "PlayerColor",

		init = function(self, mat, values)
			self.ResultTo = values.resultvar
		end,

		bind = function(self, mat, ent)
			if !IsValid(ent) then return end

			if ent:IsRagdoll() then
				local owner = ent:GetRagdollOwner()
				if IsValid(owner) then
					ent = owner
				end
			end

			if IsValid(ent) and isfunction(ent.GetPlayerColor) then
				local col = ent:GetPlayerColor()
				if isvector(col) then
					mat:SetVector(self.ResultTo, col)
				end
			else
				mat:SetVector(self.ResultTo, fallbackClr)
			end
		end
	})
end)