include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

local glow = Material("modulus_hoverboard/glow")
local trail = Material("modulus_hoverboard/trail")

local g_HoverEffects = {}

local effectfiles = file.Find("entities/hoverboard/effects/*.lua", "LUA")
for _, filename in pairs(effectfiles) do
	local old_effect = EFFECT
	EFFECT = {}
	function EFFECT:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end
	include("effects/".. filename)
	local _, _, effectname = string.find(filename, "([%w_]*)%.lua")
	g_HoverEffects[ effectname ] = EFFECT
	EFFECT = old_effect
end

function ENT:Initialize()
	self.HoverSoundFile = "weapons/gauss/chargeloop.wav"
	self.HoverSound = CreateSound(self.Entity, self.HoverSoundFile)
	self.HoverSoundPlaying = false
	self.GrindSoundFile = "physics/metal/metal_grenade_scrape_smooth_loop1.wav"
	self.GrindSound = CreateSound(self.Entity, self.GrindSoundFile)
	self.GrindSoundPlaying = false
	self.GrindSoundTime = 0
	self.BoostOffSoundFile = "npc/scanner/scanner_nearmiss1.wav"
	self.BoostOnSoundFile = "npc/scanner/scanner_nearmiss2.wav"
	self.BoostSoundFile = "ambient/levels/labs/teleport_rings_loop2.wav"
	self.BoostSound = CreateSound(self.Entity, self.BoostSoundFile)
	self:SetNW2VarProxy("Boosting", self.BoostStateChanged)
	self.Effects = {}
	self.EffectsInitailized = false
	self:SetRenderBounds(Vector(-24, -8, -16), Vector(24, 8, 16))
end

function ENT:BoostStateChanged(name, oldvalue, newvalue)
	if !IsValid(self) then return end
	if (oldvalue == newvalue) then return newvalue end
	if newvalue then
		self.BoostSound:Play()
		self:EmitSound(self.BoostOnSoundFile)
	else
		self.BoostSound:Stop()
		self:EmitSound(self.BoostOffSoundFile)
	end
	return newvalue
end

function ENT:OnRemove()
	self.HoverSound:Stop()
	self.GrindSound:Stop()
	self.BoostSound:Stop()
end

function ENT:Think()
	if (self:GetNW2Float("GrindSoundTime") > CurTime()) then
		if !self.GrindSoundPlaying then
			self.GrindSound:Play()
			self.GrindSoundPlaying = true
		end
	else
		if self.GrindSoundPlaying then
			self.GrindSound:Stop()
			self.GrindSoundPlaying = false
		end
	end
	if (!self.HoverSoundPlaying and !self:IsGrinding()) then
		self.HoverSound:SetSoundLevel(60)
		self.HoverSound:Play()
		self.HoverSoundPlaying = true
	elseif (self.HoverSoundPlaying and self:IsGrinding()) then
		self.HoverSound:Stop()
		self.HoverSoundPlaying = false
	else
		if (self:WaterLevel() == 0) then
			local speed = self:GetBoardVelocity()
			speed = speed / 700
			local soundspeed = math.Clamp(80 + (speed * 55), 80, 160)
			self.HoverSound:ChangePitch(soundspeed, 0)
		else
			self.HoverSound:ChangePitch(0, 0)
		end
	end
	if (self.HoverSoundPlaying and self:GetUp().z < 0.33) then
		self.HoverSound:Stop()
		self.HoverSoundPlaying = false
	end
	if !self.EffectsInitailized and tonumber(self:GetEffectCount()) then
		local done = true
		for i = 1, tonumber(self:GetEffectCount()) do
			if !self.Effects[i] then
				if (!self:GetNW2String("Effect"..i, false) or !self:GetNW2Vector("EffectPos"..i, false) or !self:GetNW2Vector("EffectNormal"..i, false) or !self:GetNW2Float("EffectScale"..i, false)) then
					done = false
				else
					local effectname = self:GetNW2String("Effect"..i)
					if !g_HoverEffects[effectname] then return end
					local effect = g_HoverEffects[effectname]:new()
					effect.Board = self
					effect:Init(self:GetNW2Vector("EffectPos"..i), self:GetNW2Vector("EffectNormal"..i), self:GetNW2Float("EffectScale"..i))
					self.Effects[i] = effect
				end
			end
		end
		self.EffectsInitailized = done
	end
	for _, effect in pairs(self.Effects) do
		effect:Think(_)
	end
	self:NextThink(UnPredictedCurTime())
	return true
end

function ENT:Draw()
	self:DrawModel()
	for _, effect in pairs(self.Effects) do
		effect:Render()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

hook.Add("PlayerBindPress", "Hoverboard_PlayerBindPress", function(pl, bind, pressed)
	local board = pl:GetNWEntity("ScriptedVehicle")
	if !IsValid(board) or board:GetClass() != "hoverboard" then return end
	local blocked = {"phys_swap", "slot", "invnext", "invprev", "lastinv", "gmod_tool", "gmod_toolmode"}
	for _, block in pairs(blocked) do
		if bind:find(block) then return true end
	end
end)