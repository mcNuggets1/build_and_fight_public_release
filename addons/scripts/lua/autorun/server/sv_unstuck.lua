local function SendMessage(ply, num, str)
	net.Start("StuckMessage")
		net.WriteInt(num, 8)
		net.WriteString(str)
	net.Send(ply)
end

local function FindNewPos(ply)
	local pos = ply:GetShootPos()
	local forward = ply:GetForward()
	local center = Vector(0, 0, 30)
	local realpos = ((pos + center) + (forward * 75))
	local prop = ents.Create("prop_physics")
	if !IsValid(prop) then return end
	prop:SetModel("models/props_c17/oildrum001.mdl")
	prop:SetPos(realpos)
	prop:SetNoDraw(true)
	prop:SetNotSolid(true)
	prop:DrawShadow(false)
	prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	prop:Spawn()
	prop:Activate()
	prop:SetOwner(ply)
	local phys = prop:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	local trace = {}
	trace.start = pos
	trace.endpos = prop:GetPos()
	trace.filter = ply
	local tr = util.TraceLine(trace)
	timer.Simple(3, function()
		local isvalid = IsValid(ply)
		if isvalid then
			ply:Freeze(false)
		end
		if IsValid(prop) and isvalid and prop:IsInWorld() then
			if tr.Entity == prop then
				ply:SetPos(prop:GetPos())
				SendMessage(ply, 3, "")
			else
				SendMessage(ply, 7, "")
			end
		else
			SendMessage(ply, 2, "")
		end
		SafeRemoveEntity(prop)
	end)
end

local function UnStuck(ply)
	SendMessage(ply, 1, "")
	timer.Simple(3, function()
		if IsValid(ply) then
			ply:Freeze(true)
			FindNewPos(ply)
		end
	end)
end

hook.Add("PlayerSay", "Unstuck_ChatCommand", function(ply, text)
	local txt = string.lower(text)
	if (txt == "!stuck" or txt == "!unstuck") then
		if ply.isArrested and ply:isArrested() then SendMessage(ply, 8, "") return "" end
		ply.UnStuckCooldown = ply.UnStuckCooldown or CurTime()
		if (ply.UnStuckCooldown <= CurTime()) then
			if ply:Alive() then
				if !ply:IsFrozen() then
					if ply:GetMoveType() == MOVETYPE_WALK and ply:GetObserverMode() == OBS_MODE_NONE and !ply:GetObserverTarget():IsValid() then
						ply.UnStuckCooldown = CurTime() + 10
						SendMessage(ply, 5, "")
						UnStuck(ply)
					else
						SendMessage(ply, 10, "")
					end
				else
					SendMessage(ply, 9, "")
				end
			else
				SendMessage(ply, 4, "")
			end
		else
			SendMessage(ply, 6, "")
		end
		return ""
	end
end)