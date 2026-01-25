ITEM.Name = 'Schwebesprung'
ITEM.Price = 60000
ITEM.Model = 'models/thrusters/jetpack.mdl'
ITEM.Description = "Gewährt einen leichten Schwebesprung."
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	ply:SetNW2Bool("PS_HoverJump", true)
end

function ITEM:OnHolster(ply)
	ply:SetNW2Bool("PS_HoverJump", false)
end

local function HoverJump(ply, data)
	if ply:GetNW2Bool("PS_HoverJump") and !ply:OnGround() then
		data:SetVelocity(data:GetVelocity() + Vector(0, 0, 50) * FrameTime())
	end
end

local ply_tbl = {}
local hook_exists
local function CheckHoverJump(ply, name, old, new)
	if name == "PS_HoverJump" and old != new then
		ply_tbl[ply] = new
		local found
		for k in pairs(ply_tbl) do
			if IsValid(k) then
				found = true
			else
				ply_tbl[k] = nil
			end
		end
		if found then
			if hook_exists then return end
			hook_exists = true
			hook.Add("Move", "PS_HoverJump", HoverJump)
		else
			hook_exists = nil
			hook.Remove("Move", "PS_HoverJump")
		end
	end
end
hook.Add("EntityNetworkedVarChanged", "PS_HoverJump", CheckHoverJump)