include("shared.lua")
include("wac/keyboard.lua")

local ply
local volume_cvar = GetConVar("wac_cl_air_volume")
function ENT:Think()
	local tb = self:GetTable()
	if not tb.valid then return end
	if not self:GetNWBool("locked") then
		local volume = volume_cvar:GetFloat()
		local mouseFlight = self:GetNWBool("active")
		if tb.sounds.Start and volume > 0 then
			if mouseFlight != tb.IsOn then
				if mouseFlight then
					tb.sounds.Start:Play()
				else
					tb.sounds.Start:Stop()
				end
				tb.IsOn = mouseFlight
			end
		end

		if !tb.sounds.Engine:IsPlaying() and volume > 0 then
			tb.sounds.Engine:ChangePitch(0, 0.1)
			tb.sounds.Engine:Play()
		end

		if !tb.sounds.Blades:IsPlaying() and volume > 0 then
			tb.sounds.Blades:ChangePitch(0, 0.1)
			tb.sounds.Blades:Play()
		end

		ply = ply or LocalPlayer()
		local frt=CurTime()-tb.LastThink
		local e=ply:GetViewEntity()
		if !IsValid(e) then e=ply end
		local pos=e:GetPos()
		local spos=self:GetPos()
		local doppler=(pos:Distance(spos+e:GetVelocity())-pos:Distance(spos+self:GetVelocity()))/200*tb.rotorRpm

		tb.smoothUp = tb.smoothUp - (tb.smoothUp-self:GetNWFloat("up"))*frt*10
		tb.rotorRpm = tb.rotorRpm - (tb.rotorRpm-self:GetNWFloat("rotorRpm"))*frt*10
		tb.engineRpm = tb.engineRpm - (tb.engineRpm-self:GetNWFloat("rotorRpm"))*frt*10

		local engineVal = math.Clamp(tb.engineRpm*100+tb.engineRpm*tb.smoothUp*3+doppler, 0, 200)
		local val = math.Clamp(tb.rotorRpm*100 + doppler, 0, 200)

		local vehicle = ply:GetVehicle()
		local inVehicle = false
		if --[[GetConVar("gmod_vehicle_viewmode"):GetInt() == 0 and]] vehicle and vehicle:IsValid() and vehicle:GetNetworkedEntity("wac_aircraft") == self then
			inVehicle = true
		end

		tb.sounds.Engine:ChangePitch(engineVal,0.1)
		tb.sounds.Engine:ChangeVolume(volume*math.Clamp(engineVal*engineVal/4000, 0, inVehicle and 1 or 5),0.1)
		tb.sounds.Blades:ChangePitch(math.Clamp(val, 50, 150),0.1)
		tb.sounds.Blades:ChangeVolume(volume*math.Clamp(val*val/5000, 0, inVehicle and 0.4 or 5),0.1)
		if tb.sounds.Start then
			tb.sounds.Start:ChangeVolume(volume*math.Clamp(100 - tb.engineRpm*150, 0, 100)/100,0.1)
			tb.sounds.Start:ChangePitch(100 - tb.engineRpm*30,0.1)
		end
		tb.LastThink=CurTime()
	else
		tb.sounds.Engine:Stop()
		tb.sounds.Blades:Stop()
		if tb.sounds.Start then
			tb.sounds.Start:Stop()
		end
	end
end

local vec_50_0_100 = Vector(-50,0,100)
function ENT:CalcThirdPersonView(k,p,pos,ang,view)
	local a = wac.key.down(tonumber(p:GetInfo("wac_cl_air_key_15")))
	local b=p:GetInfo("wac_cl_air_mouse")=="1"
	local c=p:GetInfo("wac_cl_air_usejoystick")=="1"
	if k==1 then
		if a then
			p.wac.heliFreeAim = true
		elseif p.wac.heliFreeAim then
			p.wac.heliFreeAim = false
			p.wac.heliResetView = true
		end
	end

	local angles
	if (k==1 and (!c and a!=b) or (c and b)) or (k!=1 and a) then
		angles = self:GetAngles()
		ang=angles
	end
	
	ang:RotateAroundAxis(self:GetRight(),-10)
	
	p.wac.viewAng = p.wac.viewAng or Angle(0,0,0)

	local m=math.Clamp(CurTime()-p.wac_air_v_time,0,1)
	if p:GetInfo("wac_cl_air_smoothview")=="1" then
		p.wac.viewAng = WAC.SmoothApproachAngles(p.wac.viewAng, ang, 10*m)
		view.angles = p.wac.viewAng
	else
		angles = angles or self:GetAngles()
		p.wac.viewAng = WAC.SmoothApproachAngles(p.wac.viewAng, ang-angles, 10*m)
		view.angles = p.wac.viewAng + angles
	end
	
	local tb = self:GetTable()
	local velocity = self:GetVelocity()/50
	local tr = util.QuickTrace(self:LocalToWorld(vec_50_0_100)+velocity,view.angles:Forward()*-tb.ThirdPDist,{self,self:GetNWEntity("rotor_rear")})
	if IsValid(tr.Entity) and (tr.Entity:GetNoDraw() or !tr.Entity:IsSolid() or tr.Entity:GetClass() == "wac_rotor") then 
		tr = util.QuickTrace(self:LocalToWorld(vec_50_0_100)+velocity,view.angles:Forward()*-tb.ThirdPDist,{self,self:GetNWEntity("rotor_rear"), tr.Entity})
	end
	view.origin=tr.HitPos-tr.Normal*10
	return view
end

function ENT:Draw()
	self:DrawModel()
	local tb = self:GetTable()
	if !tb.Seats or self:GetNWBool("locked") then return end
	local fwd = self:GetForward()
	local ri = self:GetRight()
	local ang = self:GetAngles()
	self:DrawPilotHud(tb, fwd, ri, ang)
	self:DrawWeaponSelection(tb, fwd, ri, ang)
end